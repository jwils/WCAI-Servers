class TimeEntry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :project
  attr_accessible :comment, :date, :hours_spent, :project_id

  def day_of_week

  end
end
