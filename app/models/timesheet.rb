class Timesheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approver_id'
  has_many :time_entries, :dependent => :destroy
  accepts_nested_attributes_for :time_entries, :reject_if => lambda { |a| a[:hours_spent].blank? or a[:hours_spent] == 0}, :allow_destroy => true

  attr_accessible :start_date, :submitted, :user_id, :time_entries_attributes

end
