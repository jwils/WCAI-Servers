class Ec2File < WCAIFile
  attr_accessor :directory?

  def self.create(parent, cmd_line_string)
    parts = cmd_line_string.split(' ')
    file = Ec2File.new
    file.directory? = parts[0][0] == 'd'
    file.size = parts[4].to_i
    file.path = parent + parts[8..-1].join(" ")
    file.path += '/' if file.directory?
    file
  end

  def local?
    true
  end
end