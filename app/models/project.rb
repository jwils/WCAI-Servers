class Project < ActiveRecord::Base
  resourcify
  belongs_to :user
  belongs_to :company
  has_one :server
  attr_accessible :current_state, :description, :start_date, :user_id, :folder_name, :company
  has_many :connections, :through => :server
  has_many :s3_files

  def name
    self.company.name
  end

  def company=(company)
    super(Company.find_or_create_by_name(company))
  end

  def s3_files
    S3File.find_by_project_name(folder_name + "/") unless folder_name.nil?
  end

  def find_s3_file(file_name)
    S3File.find_by_file_name(file_name) if file_name.start_with? self.folder_name
  end

  def find_encoded_s3_file(file_name)
    find_s3_file(S3File.decode(file_name))
  end
end
