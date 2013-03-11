class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true
  
  scopify

  def readable
    resource.nil? ? name : "#{name} : #{resource.name}"
  end
end
