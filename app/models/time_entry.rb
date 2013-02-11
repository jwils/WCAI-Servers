class TimeEntry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :project
  attr_accessible :comment, :date, :end_time, :start_time
end
