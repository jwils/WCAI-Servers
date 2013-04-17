class User < ActiveRecord::Base
  ROLES = %w[admin research_assistant researcher phd_student]

  rolify

  devise :invitable, :database_authenticatable, :lockable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :institution, :role_ids
  # attr_accessible :title, :body
  has_many :connections
  has_many :timesheets
  has_many :time_entries, :through => 'timesheets'

  def is?(role)
    has_role? role
  end


  def self.create_or_add_roles(email, role, project=nil)
    u = User.find_by_email(email)
    if u.nil?
      u = User.invite!(:email => email)
      u.save
      email.inspect
    else
      if role == "researcher"
        UserMailer.added_to_project(u, project).deliver
      end
    end

    if role.to_s == "researcher" or role.to_s == "phd_student"
      u.add_role(role, project)
    else
      u.add_role(role)
    end
  end

  def self.get_all_roles
    [["admin", 1], ["research_assistant", 2], ["researcher", 3], ["phd_student", 4]]
  end
end
