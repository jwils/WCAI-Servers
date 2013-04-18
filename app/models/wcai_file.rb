class WCAIFile
  attr_accessor :children, :size, :path

  def extension
    return :default if path.rindex(/\./).nil?

    ext = self.path[path.rindex(/\./) + 1..-1]
    ext.to_sym
  end

  def extension_css
    extension.to_s + " default"
  end

  def file_name
    parent_index = path.rindex(/\//, -2)
    if parent_index.nil?
      path
    else
      path[parent_index +1..-1]
    end
  end

  def parent_name
    parent_index = path.rindex(/\//, -2)
    if parent_index.nil?
      nil
    else
      path[0..parent_index]
    end
  end

  def is_directory?
    path[-1] == '/'
  end

  def str_size
    if size > 1024 * 1024 * 1024
      "%0.0f GB" % (size / (1024.0 * 1024 * 1024))
    elsif size > 1024 * 1024
      "%0.0f MB" % (size / (1024.0 * 1024))
    else
      "%0.0f KB" % (size / 1024.0)
    end
  end

  def encode
    CGI::escape(self.path.gsub(" ", "%20").gsub("/", "%2F"))
  end

  def self.decode(encoded_string)
    CGI::unescape(encoded_string).gsub("%20", " ").gsub("%2F", "/")
  end

  def persisted?
    false
  end
end