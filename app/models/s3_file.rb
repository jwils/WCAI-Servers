class S3File < WCAIFile
  attr_accessor :fog_file

  # This is really find by object key prefix. We assume all files for a given project lie
  # within a S3 Folder.
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

  #We give the full key of a file. Could be thought of as path to file.
  def self.find_by_file_name(name)
    fog_file = self.files.head(name)
    return self.convert(fog_file)
  end

  # Takes a file represented in the fog structure and converts it into something we can
  # more easily use.
  def self.convert(fog_file)
    file = S3File.new
    file.size = fog_file.content_length
    file.path = fog_file.key
    file.children = nil
    file.fog_file=fog_file
    return file
  end

  #A url for  file that expires in 1 minute. The expiration shouldn't be a problem since these
  # urls are all servered through redirection.
  def url
    expiration = Time.now + 60.seconds
    fog_file.url(expiration)
  end

  def self.files
    FOG_STORAGE.directories.get(Settings.aws_bucket).files
  end

  #Used to tell the difference between ec2 and s3 files.
  def local?
    false
  end
end
