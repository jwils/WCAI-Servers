class PassthroughController < ApplicationController
  skip_authorization_check
	def index
    flash.keep
		if current_user.nil?
			redirect_to new_user_session_path
		else
			redirect_to projects_path
		end
  end

  #DELETE after people have a chance to ajust
  def reroute_from_projects
    flash.keep
    redirect_to "/projects/#{params[:path]}"
  end
end
