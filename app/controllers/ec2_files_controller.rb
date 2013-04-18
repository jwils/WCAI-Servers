class Ec2FilesController < ApplicationController
  load_and_authorize_resource :server
  load_and_authorize_resource

  # GET /servers/:server_id/ec2_files


  # GET /servers/:server_id/ec2_files/:file
  def show
    @file = Ec2File.decode(params[:file])

    @server.download_file(@file)
    ### Should use a proc to stream
    redirect_to '/ec2_files/' + @file.split('/')[-1]
  end
end
