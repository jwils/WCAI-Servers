class ProjectFile < ActiveRecord::Base
  resourcify
  attr_accessible :project_id, :file
  belongs_to :project
  mount_uploader :file, FileUploader

  def file_base_name
  	if self.file_url.nil?
  		'No File'
  	else
  		File.basename(self.file_url).split('?')[0]
  	end
  end

end
