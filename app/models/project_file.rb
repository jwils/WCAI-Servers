class ProjectFile
  attr_accessor :children, :is_directory, :size, :path

  EXT_MAP =  {
      'xls' => :xml,
      'xlsx' => :xml,
      'doc' => :doc,
      'docx' => :doc,
  }

  def self.find_by_project_name(name)
    project_files = FOG_STORAGE.directories.get(Settings.aws_bucket).files.all({:prefix => name})
    output_files = Hash.new
    file_lookup = Hash.new 
    root = nil

    project_files.each do |project_file|
      file_lookup[project_file.key] = project_file
    end

     project_files.each do |project_file|
      parent_index = project_file.key.rindex(/\//,-2)
      if parent_index.nil?
        root = project_file
      else
        parent = file_lookup[project_file.key[0..parent_index]]
        output_files[parent.key] ||= []
        output_files[parent.key]  << project_file
      end
    end
    return root, output_files
  end


  def link
    fog_file = FOG_STORAGE.directories.get(Settings.aws_bucket).files.get(self.path)
    expiration = Time.now + 60.seconds
    fog_file.url(expiration)
  end

  def extension
    ext = self.path[root.rindex(/\./) + 1..-1]
    EXT_MAP[ext]
  end
end
