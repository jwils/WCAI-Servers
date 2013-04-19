class Ec2File < WCAIFile
  attr_accessor :directory

  # Creates and returns a Ec2File from a parent directory path
  # and a string. The string is a single line from the command
  # line method ls -l. We extract three things.
  #
  #  1. the first character is (d|-) specifying if a file or directory
  #
  #  2. The 4th column is the filesize.
  #
  #  3. The 8th column is the filename.
  #
  # Example line:
  #  File:
  #    -rw-r--r--   1 jwils  staff     1283 Apr 16 09:52 file.txt
  #  Directory:
  #    drwxr-xr-x  10 jwils  staff      340 Feb 15 04:36 directory
  #
  def self.create(parent, cmd_line_string)
    parts = cmd_line_string.split(' ')
    file = Ec2File.new
    file.directory = parts[0][0] == 'd'
    file.size = parts[4].to_i
    file.path = parent + parts[8..-1].join(" ")
    file.path += '/' if file.directory?
    file
  end

  # Returns a boolean.
  #   True if file is a directory.
  #   False if a file
  def directory?
    directory
  end

  # This is really a way to distinguish between s3 and ec2 files.
  #
  # true means local to an ec2 machine.
  #
  # false is a ec2 file.
  #
  # Possible rename? Also could just check if instance of but seems less clean
  def local?
    true
  end
end