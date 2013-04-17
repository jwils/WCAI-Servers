class S3FilesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource
  # GET /project_files
  # GET /project_files.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project.s3_files }
    end
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    @file = @project.find_encoded_s3_file(params[:file])
    return redirect_to root_path, :alert => "Unknown or unauthorized file." if @file.nil?

    DownloadsTracker.track(current_user, @file, params[:project_id])
    redirect_to @file.url
  end
end
