class TimeEntry < ActiveRecord::Base
  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

  attr_accessible :comment, :day, :hours_spent, :project_id

  belongs_to :timesheet
  belongs_to :project

  # Returns the string name of the day of week attribute.
  # TODO: I believe DAYS can be accessed through locales some how.
  #       check for how to do this.
  def day_of_week
    DAYS[self.day]
  end
end
