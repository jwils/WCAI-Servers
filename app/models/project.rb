class Project < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :company
  has_one :server
  attr_accessible :current_state, :description, :start_date, :user_id, :company_id
  has_many :job_requests
  has_many :connections, :through => :server
  has_many :project_files
end
