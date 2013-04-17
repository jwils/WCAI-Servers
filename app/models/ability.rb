class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
      cannot :approve, Timesheet, :user_id => user.id
      cannot :toggle_lock, user
    elsif user.has_role? :research_assistant
      can :manage, Timesheet, :user_id => user.id
      cannot :approve, Timesheet
      cannot :edit, Timesheet, :submitted => true
      #can :create, Timesheet
      can :manage, Connection, :user_id => user.id
      #can :create, Connection
      can :manage, Server
      can :manage, Project
      can :manage, S3File
      can :manage, Message
      can :read, User
    else
      authorized_projects = Project.with_role(:researcher, user)
      can :manage, Message
      can :read, User
      can :read, Project, :id => authorized_projects.map { |project| project.id }
      can :read, S3File
    end
  end
end
