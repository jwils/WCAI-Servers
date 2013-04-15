class S3FilesController < ApplicationController
  load_and_authorize_resource
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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project.s3_files }
    end
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    @file = Project.find(params[:project_id]).find_encoded_s3_file(params[:file])
    unless @file.nil?
      DownloadsTracker.track(current_user, @file)
      redirect_to @file.url
    else
      redirect_to root_path, :alert => "Unknown or unauthorized file."
    end
  end
end
