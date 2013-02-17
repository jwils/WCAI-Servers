class ProjectFilesController < ApplicationController
  # GET /project_files
  # GET /project_files.json
  before_filter :check_auth

  def check_auth
    project =  Project.find(params[:project_id])

    if not current_user or  not (current_user.has_role? :admin or current_user.has_role? :researcher, project)
	    redirect_to root_path
    end
  end

  def index
    @project =  Project.find(params[:project_id])
    if @project.folder_name.nil?
       @root = nil
    else
       @root = ProjectFile.find_by_project_name(@project.folder_name + "/")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_files }
    end
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    @file_name = CGI::unescape(params[:file]).gsub("%20"," ").gsub("%2F","/")
    @project_file, file_size = ProjectFile.find_link_by_name(@file_name)
    tracker_file = DownloadsTracker.create(:file_name => params[:file],
                                           :file_size => file_size)
    tracker_file.user = current_user
    tracker_file.save

    redirect_to @project_file
  end
end
