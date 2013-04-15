class Ec2FilesController < ApplicationController
  load_and_authorize_resource

  def index
    @project =  Project.find(params[:project_id])
    if @project.server.ready?
      @root = @project.server.get_files('/var/files/')
    else
      @root = nil
    end
  end

  def show
    @file_name = CGI::unescape(params[:file]).gsub("%20"," ").gsub("%2F","/")
    @project =  Project.find(params[:project_id])

    @project.server.download_file(@file_name)
    redirect_to '/ec2_files/' + @file_name.split('/')[-1]
  end
end
