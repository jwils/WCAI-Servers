require 'net/scp'

class Ec2FilesController < ApplicationController
  load_and_authorize_resource :server

  def index
  end

  def show
    @file = Ec2File.decode(params[:file])

    @server.download_file(@file)
    ### Shoud use a proc to stream
    redirect_to '/ec2_files/' + @file.split('/')[-1]
  end
end
