class Project < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :company
  has_one :server
  attr_accessible :current_state, :description, :start_date, :user_id, :company_id, :folder_name
  has_many :connections, :through => :server
  has_many :s3_files

  def name
    self.company.name
  end
end
