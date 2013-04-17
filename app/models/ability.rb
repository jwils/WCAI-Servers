class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new

      if user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :research_assistant
        can :manage, Timesheet, :id => user.timesheets.map{ |timesheet| timesheet.id}
        cannot :approve, Timesheet
        can :create, Timesheet
        can :manage, Connection
        can :create, Connection
        can :manage, Server
        can :manage, Project
        can :manage, S3File
        can :manage, Message
        can :read, User
      else
        authorized_projects = Project.with_role(:researcher, user)
        can :manage, Message
        can :read, User
        can :read, Project, :id => authorized_projects.map{ |project| project.id}
        can :read, S3File
      end
  end
end
