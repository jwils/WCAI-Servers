class ApplicationController < ActionController::Base
  protect_from_forgery

  # Users need to be logged in before allowed access anything on the website.
  before_filter :authenticate_user!, :unless => :devise_controller?

  # check_authorization ensures that cancan will check access to every controller action. Unless a controller implements
  # an authorization check or makes an explicit call to skip_authorization_check the controller will throw an exception.
  #
  # This makes sure authorization is considered for every model that loads.
  #
  # More information on cancan can be found at https://github.com/ryanb/cancan/blob/master/README.rdoc
  #
  check_authorization :unless => :devise_controller?


  #  If a user tries to go to a url where they do not have permission a exception is thrown. This catches the exception
  #  redirects them to the root url and alerts them.
  #
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

end
