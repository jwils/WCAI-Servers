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
end
