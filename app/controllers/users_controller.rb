class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :prepare_roles
  before_filter :check_admin

  def new
    # If you're not using CanCan, raise some other exception, or redirect as you please
    super
  end

  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def new_batch
    @projects = Project.all
    respond_to do |format|
      format.html # new.html.erb
    end

  end

  def batch_invite
    @role = @roles[params[:invitations][:role].to_i - 1][0]
    @project = Project.find(params[:invitations][:project])

    params[:invitations][:user_emails].split("\n").each do |email|
      u = User.find_by_email(email)
      if u.nil?
        u = User.invite!(:email => email)
      end
      if @role == "researcher"
         u.add_role(:researcher, @project)
      else
        u.add_role(@role)
      end
    end
      redirect_to root_path, :notice => 'Email invitations sent'
  end

  def toggle_lock
    @u = User.find(params[:id])
    if @u.access_locked?
      @u.unlock_access!
    else
      @u.lock_access!
    end
    respond_to do |format|
      format.html { redirect_to redirect_to(:back)}
      format.json { head :no_content }
    end
  end

  protected

  def prepare_roles
    @roles = [["admin", 1], ["research_assistant", 2], ["researcher", 3]]
  end

  def check_admin
    unless current_user and current_user.is? :admin
      raise CanCan::AccessDenied
    end
  end
end
