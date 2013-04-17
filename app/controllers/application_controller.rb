class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  before_filter :check_logged_in, :unless => :devise_controller?

  private

  def check_logged_in
    if current_user.nil?
      flash[:notice] = "Please login first"
      redirect_to new_user_session_path
    end
  end
end
