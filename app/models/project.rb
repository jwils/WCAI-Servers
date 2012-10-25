class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :server
  attr_accessible :current_state, :description, :start_date
  has_many :job_requests
end
