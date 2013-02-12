class TimeEntry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :project
  attr_accessible :comment, :date, :hours_spent
end
