class ConnectionsController < ApplicationController
  load_and_authorize_resource
  # GET /connections
  # GET /connections.json
  def index
    if params[:server_id]
      @connections = Server.find(params[:server_id]).connections.only_open
    elsif params[:user_id]
      @connections = User.find(params[:user_id]).connections.only_open
    else
      @connections = Connection.only_open
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @connections }
    end
  end

  # GET /connections/1
  # GET /connections/1.json
  def show
    @connection = Connection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @connection }
    end
  end

  def destroy
    @connection = Connection.find(params[:id])
    @connection.close_connection
    respond_to do |format|
      format.html { redirect_to server_connections_url(@connection.server), notice: 'Connection was successfully closed.' }
      format.json { render json: @connection, status: :created, location: @connection }
    end
  end

  def new
    @server = Server.find(params[:server_id]).open_connection(current_user, request.remote_ip)

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
