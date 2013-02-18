class PassthroughController < ApplicationController
  skip_authorization_check
	def index
    flash.keep
		if current_user.nil?
			redirect_to new_user_session_path
		elsif current_user.has_role? :admin
			redirect_to projects_path
		else 
			Project.all.each do |project|
				if current_user.has_role? :researcher, project
					redirect_to projects_path
					return
				end
			end
		end
	end
end
