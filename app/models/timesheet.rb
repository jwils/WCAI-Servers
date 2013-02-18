class Timesheet < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approver_id'
  has_many :time_entries, :dependent => :destroy
  accepts_nested_attributes_for :time_entries, :reject_if => lambda { |a| a[:hours_spent].blank? or a[:hours_spent] == 0}, :allow_destroy => true

  attr_accessible :start_date, :submitted, :user_id, :time_entries_attributes


  def status_string
    if approver.nil?
      if submitted
        'Submitted'
      else
        'Draft'
      end
    else
     "Approved by #{approver.name}"
    end
  end

  def hours
    time_entries.sum :hours_spent
  end
end
