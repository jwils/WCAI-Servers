class TimeEntry < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :project
  attr_accessible :comment, :day, :hours_spent, :project_id

  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

  def day_of_week
    DAYS[self.day]
  end
end
