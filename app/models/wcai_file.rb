class WCAIFile
  attr_accessor :children, :size, :path

  EXT_MAP =  {
      'xls'  => :xls,
      'xlsx' => :xls,
      'doc'  => :doc,
      'docx' => :doc,
      'zip'  => :zip,
      'txt'  => :txt,
      'pdf'  => :pdf,
      'sql'  => :sql,
  }

  def extension
    ext = self.path[path.rindex(/\./) + 1..-1]
    EXT_MAP[ext]
  end

  def extension_css
    unless extension.nil?
      extension.to_s
    else
      "default"
    end
  end

  def file_name
    parent_index = path.rindex(/\//,-2)
    if parent_index.nil?
      path
    else
      path[parent_index +1..-1]
    end
  end

  def parent_name
    parent_index = path.rindex(/\//,-2)
    if parent_index.nil?
      nil
    else
      path[0..parent_index]
    end
  end

  def is_directory?
    not children.nil?
  end

  def str_size
    if size > 1024 * 1024 * 1024
      "%0.0f GB" % (size / (1024.0 * 1024 * 1024))
    elsif size > 1024 * 1024
      "%0.0f MB" % (size / (1024.0 * 1024 ))
    else
      "%0.0f KB" % (size / 1024.0)
    end
  end

  def encode
    CGI::escape(self.path.gsub(" ","%20").gsub("/","%2F"))
  end

  def self.decode(encoded_string)
    CGI::unescape(encoded_string).gsub("%20"," ").gsub("%2F","/")
  end

  def persisted?
    false
  end
end