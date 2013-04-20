# Links to an s3 bucket folder.
#
# @project is defined and authorized for users by cancan
#
# Handles but not shown: GET /projects/:project_id/project_files
class S3FilesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource

  # GET /projects/:project_id/project_files/1
  def show
    @file = @project.find_s3_file(S3File.decode(params[:file]))
    if @file.nil?
      redirect_to root_path, :alert => "Unknown or unauthorized file." if @file.nil?
    else
      DownloadsTracker.track(current_user, @file, params[:project_id])
      redirect_to @file.url
    end
  end
end
