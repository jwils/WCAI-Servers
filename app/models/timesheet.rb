class Timesheet < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :approver, :class_name => 'User', :foreign_key => 'approver_id'
  has_many :time_entries, :dependent => :destroy, :order => 'day'
  accepts_nested_attributes_for :time_entries, :reject_if => lambda { |a| a[:hours_spent].blank? or a[:hours_spent] == 0}, :allow_destroy => true

  default_scope :include => :time_entries
  attr_accessible :start_date, :submitted, :user, :time_entries_attributes, :user_id
  before_save :check_for_time
  before_save :mark_entries_for_removal

  scope :not_printed, where(:last_printed => nil, :submitted => true)

  scope :submitted, where(:submitted => true)

  scope :not_submitted, where(:submitted => false)

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

  def printing
    self.last_printed = DateTime.now
    save
  end

  def check_for_time
    self.submitted_date = DateTime.now if submitted and self.submitted_date.nil?
    self.approved_date = DateTime.now if approver and self.approved_date.nil?
  end

  def hours
    time_entries.sum(:hours_spent)
  end

  def mark_entries_for_removal
    time_entries.each do |entry|
      entry.mark_for_destruction if entry.hours_spent <= 0
    end
  end
end
