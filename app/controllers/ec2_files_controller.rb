class Ec2FilesController < ApplicationController
  load_and_authorize_resource :server

  # GET /projects/:id/
  # GET /projects.json
  def index
    raise CanCan::AccessDenied unless can? :read, Ec2File
  end

  def show
    raise CanCan::AccessDenied unless can? :read, @file

    @file = Ec2File.decode(params[:file])

    @server.download_file(@file)
    ### Shoud use a proc to stream
    redirect_to '/ec2_files/' + @file.split('/')[-1]
  end
end
