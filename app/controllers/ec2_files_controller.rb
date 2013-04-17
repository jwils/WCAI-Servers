class Ec2FilesController < ApplicationController
  load_and_authorize_resource :project

  def index
  end

  def show
    @file_name = Ec2File.decode(params[:file])
    @project.server.download_file(@file_name)
    ### Shoud use a proc to stream
    redirect_to '/ec2_files/' + @file_name.split('/')[-1]
  end
end
