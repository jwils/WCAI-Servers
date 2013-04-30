class Ability
  include CanCan::Ability

  # Defines abilities for the 4 types of users:
  # - Admin
  # - Research Assistant
  # - Researcher (on project)
  # - PhD Student (on project)
  def initialize(user)
    user ||= User.new
    can :manage, Message
    can :read, User

    if user.has_role? :admin
      can :manage, :all
      cannot :approve, Timesheet, :user_id => user.id
      cannot :toggle_lock, user
    elsif user.has_role? :research_assistant
      can :manage, Timesheet, :user_id => user.id
      cannot :approve, Timesheet
      cannot :edit, Timesheet, :submitted => true
      can :manage, Connection, :user_id => user.id
      can :manage, Server
      cannot :create, Server
      can :manage, Project
      can :manage, S3File
      can :manage, Ec2File
    else
      authorized_researcher_projects = Project.with_role(:researcher, user)
      authorized_phd_projects = Project.with_role(:phd_student, user)
      authorized_projects = (authorized_researcher_projects + authorized_phd_projects).uniq
      can :read, Project, :id => authorized_projects.map { |project| project.id }
      can :read, S3File
      if authorized_phd_projects.any?
        can :manage, Connection, :user_id => user.id
        can :manage, Server, :project_id => authorized_phd_projects.map { |project| project.id }
        cannot :create, Server
        can :manage, Ec2File
      end
    end
  end
end
