class ProjectFile < ActiveRecord::Base
  attr_accessible :project_id, :file
  belongs_to :project
  mount_uploader :file, FileUploader
end
