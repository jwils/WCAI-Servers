class Ec2FilesController < ApplicationController
  load_and_authorize_resource :project

  def index
    #@project =  Project.find(params[:project_id])

  end

  def show
    #@project =  Project.find(params[:project_id])

    @project.server.download_encoded_file(params[:file])
    @file_name = CGI::unescape(params[:file]).gsub("%20"," ").gsub("%2F","/") #Rreplace the redirect with something better
    ### SHOULD USE A PROC TO stream
    redirect_to '/ec2_files/' + @file_name.split('/')[-1]
  end
end
