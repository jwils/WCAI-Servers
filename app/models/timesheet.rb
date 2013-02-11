class Timesheet < ActiveRecord::Base
  belongs_to :user
  attr_accessible :start_date
end
