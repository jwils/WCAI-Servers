class JobRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :assignee
  belongs_to :requester
  attr_accessible :description, :priority
end
