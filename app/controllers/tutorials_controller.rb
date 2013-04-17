class TutorialsController < ApplicationController
  skip_authorization_check

  def create_projects
    raise CanCan::AccessDenied  unless can? :create, Project
  end

  def create_users
    raise CanCan::AccessDenied  unless can? :create, User
  end

  def disable_user
    raise CanCan::AccessDenied  unless can? :create, User
  end

  def downloading_files
  end

  def linking_aws_folders
    raise CanCan::AccessDenied  unless can? :create, Project
  end

  def upload_files
    raise CanCan::AccessDenied  unless can? :create, Project
  end
end