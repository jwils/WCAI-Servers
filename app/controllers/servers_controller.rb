class ServersController < ApplicationController
  load_and_authorize_resource

  # Definition is implicit of many methods. Cancan handles resources and access.
  # Below are the defined paths and routes:
  #
  # GET /servers
  # def index
  #
  # GET /servers/new
  # def new
  #
  # GET /servers/1/edit
  # def edit
  #

  # POST /servers
  def create
    @server = Server.new(params[:server])
    @server.configure(params[:schema_name])

    if @server.save
      redirect_to @server, notice: 'Server was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /servers/1
  def update
    if @server.update_attributes(params[:server])
      redirect_to @server, notice: 'Server was successfully updated.'
    else
      render json: @server.errors, status: :unprocessable_entity
    end
  end

# GET /servers/start
  def start
    @server.start
    redirect_to @server
  end

  # GET /servers/stop
  def stop
    @server.stop
    redirect_to @server
  end

  # DELETE /servers/1
  def destroy
    @server.destroy
    redirect_to servers_url
  end
end
