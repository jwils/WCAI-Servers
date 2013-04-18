class ProjectsController < ApplicationController
  load_and_authorize_resource

  # Definition is implicit of many methods. Cancan handles resources and access.
  # Below are the defined paths and routes:
  #
  # GET /projects
  # def index
  #
  # GET /projects/new
  # def new
  #
  # GET /projects/1/edit
  # def edit
  #

  # GET /projects/1
  def show
    @users = User.with_role(:researcher, @project)
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    if @project.server
      #@project.server.destroy
    end

    @project.destroy
    redirect_to projects_url
  end
end
