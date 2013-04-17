class S3File < WCAIFile
  attr_accessor :fog_file

  def self.find_by_project_name(name)
    project_files = self.files.all({:prefix => name})
    file_lookup = Hash.new
    root = nil

    project_files.each do |project_file|
      file_lookup[project_file.key] = convert(project_file)
    end

    file_lookup.values.each do |project_file|
      if project_file.parent_name.nil?
        root = project_file
      else
        parent = file_lookup[project_file.parent_name]
        parent.children ||= []
        parent.children << project_file
      end
    end
    return root
  end

  def self.find_by_file_name(name)
    fog_file = self.files.head(name)
    return self.convert(fog_file)
  end

  def self.convert(fog_file)
    file = S3File.new
    file.size = fog_file.content_length
    file.path = fog_file.key
    file.children = nil
    file.fog_file=fog_file
    return file
  end

  def url
    expiration = Time.now + 60.seconds
    fog_file.url(expiration)
  end

  def self.files
    FOG_STORAGE.directories.get(Settings.aws_bucket).files
  end

  def local?
    false
  end
end
