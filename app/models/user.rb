class User < ActiveRecord::Base
  rolify

  devise :invitable, :database_authenticatable, :lockable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :institution
  # attr_accessible :title, :body
  has_many :connections

  def is?(role)
    has_role? role
  end
end
