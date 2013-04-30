class User < ActiveRecord::Base
  # List all roles a user can have.
  # May want to destinguish between universal and project specific roles.
  ROLES = %w[admin research_assistant researcher phd_student]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :institution, :role_ids
  # attr_accessible :title, :body

  has_many :connections
  has_many :timesheets
  has_many :time_entries, :through => 'timesheets'
  has_many :downloads_trackers

  rolify
  devise :invitable, :database_authenticatable, :lockable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is?(role)
    has_role? role
  end

  # If no name is stored (means user didn't fill it out yet) we call them unregistered.
  def name
    super.nil? ? "Unregistered" : super
  end

  # Create a user from an email address and send them an invite.
  # or if the user already exists add the role and send an email.
  def self.create_or_add_roles(email, role, project=nil)
    u = User.find_by_email(email)
    if u.nil?
      u = User.invite!(:email => email)
      u.save
      email.inspect
    else
      if role.to_s == "researcher" or role.to_s == "phd_student"
        UserMailer.added_to_project(u, project).deliver
      end
    end

    if role.to_s == "researcher" or role.to_s == "phd_student"
      u.add_role(role, project)
    else
      u.add_role(role)
    end
  end

  # Returns the total size of files downloaded. Note this can be an overestimate if users
  # cancel downloads. We have no way of tracking this case so this estimate will have to do.
  def total_downloads_size
    downloads_trackers.sum(:file_size)
  end

  # Pretty urls.
  def to_param
    "#{id} #{name}".parameterize
  end
end
