class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate_user!
  def new
    # If you're not using CanCan, raise some other exception, or redirect as you please
    if not current_user.nil? and current_user.role? :admin
      super
	else
		raise CanCan::AccessDenied
	end
  end
end