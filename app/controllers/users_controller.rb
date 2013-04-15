class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :prepare_roles
  before_filter :check_admin

  def new
    raise CanCan::AccessDenied
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

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def batch_invite
    @role = @roles[params[:invitations][:role].to_i - 1][0]
    @project = Project.find(params[:invitations][:project]) unless params[:invitations][:project].nil?
    params[:invitations][:user_emails].split("\n").each do |email|
      User.create_or_add_roles(email, @role, @project)
    end
    redirect_to root_path, :notice => 'Email invitations sent'
  end

  def show
     @user = User.find(params[:id])
  end

  def toggle_lock
    @user = User.find(params[:id])
    if @user.access_locked?
      @response = "unlocked"
      @user.unlock_access!
    else
      @response = "locked"
      @user.lock_access!
    end
    render 'toggle_lock', :formats => [:js]
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
