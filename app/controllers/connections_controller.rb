class ConnectionsController < ApplicationController
  load_and_authorize_resource :server
  load_and_authorize_resource :connection, :through => :server

  # GET /connections
  # GET /connections.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @connections }
    end
  end

  # GET /connections/1
  # GET /connections/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @connection }
    end
  end

  #
  #
  def destroy
    @connection.close_connection
    respond_to do |format|
      format.html { redirect_to server_connections_url(@connection.server), notice: 'Connection was successfully closed.' }
      format.json { render json: @connection, status: :created, location: @connection }
    end
  end

  def new
    @connection = @server.open_connection(current_user, request.remote_ip)

    respond_to do |format|
      if @connection.save
        format.html { redirect_to server_connection_url(@connection.server, @connection), notice: 'Connection was successfully created.' }
        format.json { render json: @connection, status: :created, location: @connection }
      else
        format.html { render json: @connection.errors, status: :unprocessable_entity }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end
end
