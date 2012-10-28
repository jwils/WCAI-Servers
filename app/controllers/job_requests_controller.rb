class JobRequestsController < ApplicationController
  # GET /job_requests
  # GET /job_requests.json
  def index
    project = Project.find(params[:id])
    @job_requests = project.job_requests

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @job_requests }
    end
  end

  # GET /job_requests/1
  # GET /job_requests/1.json
  def show
    @job_request = JobRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job_request }
    end
  end

  # GET /job_requests/new
  # GET /job_requests/new.json
  def new
    @job_request = JobRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_request }
    end
  end

  # GET /job_requests/1/edit
  def edit
    @job_request = JobRequest.find(params[:id])
  end

  # POST /job_requests
  # POST /job_requests.json
  def create
    @job_request = JobRequest.new(params[:job_request])

    respond_to do |format|
      if @job_request.save
        format.html { redirect_to @job_request, notice: 'Job request was successfully created.' }
        format.json { render json: @job_request, status: :created, location: @job_request }
      else
        format.html { render action: "new" }
        format.json { render json: @job_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /job_requests/1
  # PUT /job_requests/1.json
  def update
    @job_request = JobRequest.find(params[:id])

    respond_to do |format|
      if @job_request.update_attributes(params[:job_request])
        format.html { redirect_to @job_request, notice: 'Job request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_requests/1
  # DELETE /job_requests/1.json
  def destroy
    @job_request = JobRequest.find(params[:id])
    @job_request.destroy

    respond_to do |format|
      format.html { redirect_to job_requests_url }
      format.json { head :no_content }
    end
  end
end
