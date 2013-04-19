class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  scopify

  def readable
    resource.nil? ? name.humanize : "#{name.humanize}: #{resource.name}"
  end

  def self.create_roles(project)
    create_role('researcher', project)
    create_role('phd_student', project)
  end

  def self.create_role(type, project)
    r =  Role.find_by_name_and_resource_id(type, project)
    if r.nil?
      r = Role.new
      r.name = type
      r.resource = project
      r.save
    end
  end
end
