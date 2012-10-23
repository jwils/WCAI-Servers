class JobRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :assignee, :class_name =>"User", :foreign_key => "assignee_id" 
  belongs_to :requester, :class_name =>"User", :foreign_key => "requester_id"
  attr_accessible :description, :priority
end
