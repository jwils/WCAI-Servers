class TimeEntry < ActiveRecord::Base
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

  attr_accessible :comment, :day, :hours_spent, :project_id

  belongs_to :timesheet
  belongs_to :project

  def day_of_week
    DAYS[self.day]
  end
end
