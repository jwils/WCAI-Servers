# This is probably not needed anymore. Will keep for now in case there is a reason
# to redirect people based on their roles
class PassthroughController < ApplicationController
  skip_authorization_check

  # root_url
  #
  # GET /
  def index
    flash.keep
    if current_user.nil?
      redirect_to new_user_session_path
    else
      redirect_to projects_path
    end
  end
end
