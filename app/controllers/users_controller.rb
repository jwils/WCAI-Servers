class UsersController < ApplicationController
  before_filter :authenticate_user!
  def new
    # If you're not using CanCan, raise some other exception, or redirect as you please
    if not current_user.nil? and current_user.role? :admin
      super
	  else
		  raise CanCan::AccessDenied
	  end
  end


  def new_batch
    @roles = Role.all
    @projects = Project.all
    respond_to do |format|
      format.html # new.html.erb
    end

  end

  def batch_invite
    @role = Role.find(params[:invitations][:role])
    @project = Project.find(params[:invitations][:project])

    params[:invitations][:user_emails].split("\n").each do |email|
      u = User.find_by_email(email)
      if u.nil?
        u = User.invite!(:email => email)
      end
      if @role.name == "researcher"
         u.add_role(@researcher, @project)
      else
        u.add_role(@role)
      end
    end
    redirect_to root_path, notice: "Emails invitations sent"
  end
end