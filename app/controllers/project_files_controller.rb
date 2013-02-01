class ProjectFilesController < ApplicationController
  # GET /project_files
  # GET /project_files.json
  before_filter :check_auth,  :except => :show

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
    @file_name = CGI::unescape(params[:id]).sub("^",".")
    @project_file = ProjectFile.find_link_by_name(@file_name)
    redirect_to @project_file
  end
end
