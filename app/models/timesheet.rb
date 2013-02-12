class Timesheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approver_id'
  has_many :time_entries

  attr_accessible :start_date, :submitted
end
