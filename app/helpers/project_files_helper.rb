module ProjectFilesHelper
  def print_directory_structure(aws_root, values)
    expiration = Time.now + 100000.seconds
    root = aws_root.key
    response_string = "<li class=\"page"

    if not values[root].nil?
      response_string += "\">\n"
      name = root
      response_string += name
      response_string += "<ul class=\"file_list\">"
      values[root].each do |value|
        response_string += print_directory_structure(value, values)
      end
      response_string += "</ul>"
    else
      if aws_root.content_length > 1024 * 1024 * 1024
        response_string += " large_file"
      end

      if root.end_with? '.xls' or root.end_with? '.xlsx'
        response_string += " xls\">\n"
      else
        response_string += " default\">\n"
      end
      
      parent_index = root.rindex(/\//,-2)
      response_string += "<a href=\"" + aws_root.url(expiration) + "\">"
      if parent_index.nil?
        name = root
      else
        name = root[parent_index +1..-1]
      end
      response_string += name + " (" + file_size(aws_root.content_length) + ") </a>\n"
    end
    response_string += "</li>\n"
    response_string.html_safe
  end

  def file_size(size)
    if size > 1024 * 1024 * 1024
      "%0.0f GB" % (size / (1024 * 1024 * 1024))
    elsif size > 1024 * 1024
      "%0.0f MB" % (size / (1024 * 1024 ))
    else
      "%0.0f KB" % (size / 1024)
    end
  end
end
