class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  protect_from_forgery
  check_authorization :unless => :devise_controller?

  before_filter :authenticate_user!, :unless => :devise_controller?
end
