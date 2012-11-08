class ProjectFilesController < ApplicationController
  # GET /project_files
  # GET /project_files.json
  def index
    @project_files = ProjectFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_files }
    end
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    @project_file = ProjectFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_file }
    end
  end

  # GET /project_files/new
  # GET /project_files/new.json
  def new
    @project_file = ProjectFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_file }
    end
  end

  # GET /project_files/1/edit
  def edit
    @project_file = ProjectFile.find(params[:id])
  end

  # POST /project_files
  # POST /project_files.json
  def create
    @project_file = ProjectFile.new(params[:project_file])

    respond_to do |format|
      if @project_file.save
        format.html { redirect_to @project_file, notice: 'Project file was successfully created.' }
        format.json { render json: @project_file, status: :created, location: @project_file }
      else
        format.html { render action: "new" }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_files/1
  # PUT /project_files/1.json
  def update
    @project_file = ProjectFile.find(params[:id])

    respond_to do |format|
      if @project_file.update_attributes(params[:project_file])
        format.html { redirect_to @project_file, notice: 'Project file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_files/1
  # DELETE /project_files/1.json
  def destroy
    @project_file = ProjectFile.find(params[:id])
    @project_file.destroy

    respond_to do |format|
      format.html { redirect_to project_files_url }
      format.json { head :no_content }
    end
  end
end
