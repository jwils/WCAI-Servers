module ProjectFilesHelper
  def print_directory_structure(root)
    response_string = ""
    response_string << "<li class=\"page\">\n"
    response_string += root.file_name
    response_string += "<ul class=\"file_list\">\n"
    root.children.each do |value|
      if value.is_directory?
        response_string += print_directory_structure(value)
      else
          response_string += "<li class=\"page #{value.extension_css} #{"large_file" if value.size > 1024 * 1024 * 1024}\">"
          response_string += link_to value.file_name + " (#{value.str_size})", project_file_path(CGI::escape(value.path.gsub(" ","%20").gsub("/","%2F"))), :target => '_blank'
          response_string += "</li>"
      end
    end
    response_string += "</ul></li>\n"
    response_string.html_safe
  end
end
