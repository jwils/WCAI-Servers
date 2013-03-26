class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new

      if user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :research_assistant
        can :manage, Timesheet, :id => user.timesheets.map{ |timesheet| timesheet.id}
        can :create, Timesheet
        can :manage, Connection, :id => user.connections.map{ |connection| connection.id}
        can :create, Connection
        can :manage, Project
        can :manage, ProjectFile
        can :manage, Message
        can :read, User
      else
        authorized_projects = Project.with_role(:researcher, user)
        can :manage, Message
        can :read, User
        can :read, Project, :id => authorized_projects.map{ |project| project.id}
        can :read, ProjectFile
      end
  end
end
