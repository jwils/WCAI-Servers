class Project < ActiveRecord::Base
  attr_accessible :current_state, :description, :start_date, :user_id, :folder_name, :company

  belongs_to :user
  belongs_to :company

  has_one :server
  has_many :connections, :through => :server
  has_many :s3_files

  after_create :create_roles

  resourcify


  # Returns the company name.
  # We have decided to make this === to project name.
  # Although company is a different database for now it is a 1-to-1
  # mapping to projects
  def name
    self.company.name unless company.nil?
  end

  # Since we have made company the same as a project name it is filled out in the form as a string.
  # The string creates a company which is the expected value.
  def company=(company)
    super(Company.find_or_create_by_name(company))
  end

  # Returns a nested hash of all files associated with the proejct.
  def s3_files
    S3File.find_by_project_name(folder_name + "/") unless folder_name.nil?
  end

  # Returns a single s3 file.
  #
  # This function is useful because it includes a security check.
  # Unlike a call to S3File.file_by_file_name we first check that the prefixes match.
  # This means trying to fetch a file from another directory fails.
  def find_s3_file(file_name)
    S3File.find_by_file_name(file_name) if file_name.start_with? self.folder_name
  end

  # Numbers are boring. This just adds the company name to the url.
  # Looks a bit nicer for users.
  def to_param
    "#{id} #{company.name}".parameterize
  end

  protected
  # Creates roles for the project so they list on the users/show checkboxes.
  def create_roles
    Role.create_roles(self)
  end
end
