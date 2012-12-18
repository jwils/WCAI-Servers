class ProjectFilesController < ApplicationController
  # GET /project_files
  # GET /project_files.json
  before_filter :check_auth

  def check_auth
    project =  Project.find(params[:project_id])
    if not (current_user.has_role? :admin or current_user.has_role? :researcher, project)
      raise CanCan::AccessDenied
    end
  end

  def index
    @project =  Project.find(params[:project_id])
    @root, @project_files = ProjectFile.find_by_project_name('PGandE')



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_files }
    end
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    @project_file = ProjectFile.find(params[:id])

    redirect_to @project_file.file_url
  end
end
