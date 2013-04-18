class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :prepare_roles

  # Definition is implicit of many methods. Cancan handles resources and access.
  # Below are the defined paths and routes:
  #
  # GET /users
  # def index
  #
  # GET /users/1
  # def show
  #

  # Probably won't need this but leaving it just in case.
  def new
    raise CanCan::AccessDenied
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

  def toggle_lock
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
    @roles = User::ROLES.zip(0..User::ROLES.length)
  end
end
