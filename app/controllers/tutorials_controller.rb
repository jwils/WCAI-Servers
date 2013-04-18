class TutorialsController < ApplicationController
  skip_authorization_check
  before_filter :can_create_project?, :only => [:create_projects, :linking_aws_folders, :upload_files]
  before_filter :can_create_user?, :only => [:create_users, :disable_user]
  # Definition is implicit of many methods. Cancan handles resources and access.
  # Below are the defined paths and routes:
  #
  # GET /tutorials/create_users
  # def create_users
  #
  # GET /tutorials/create_projects
  # def create_projects
  #
  # GET /tutorials/upload_files
  # def upload_files
  #
  # GET /tutorials/disable_user
  # def disable_user
  #
  # GET /tutorials/linking_aws_folders
  # def linking_aws_folders
  #
  # GET /tutorials/downloading_files
  # def downloading_files


  protected

  def can_create_project?
    raise CanCan::AccessDenied unless can? :create, Project
  end

  def can_create_user?
    raise CanCan::AccessDenied unless can? :create, User
  end
end