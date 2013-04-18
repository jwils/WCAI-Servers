class S3FilesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource

  # GET /projects/:project_id/project_files

  # GET /projects/:project_id/project_files/1
  def show
    @file = @project.find_encoded_s3_file(params[:file])
    return redirect_to root_path, :alert => "Unknown or unauthorized file." if @file.nil?

    DownloadsTracker.track(current_user, @file, params[:project_id])
    redirect_to @file.url
  end
end
