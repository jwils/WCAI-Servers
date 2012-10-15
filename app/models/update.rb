class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :job_request
  attr_accessible :description
end
