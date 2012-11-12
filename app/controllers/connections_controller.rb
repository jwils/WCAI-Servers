class ConnectionsController < ApplicationController
  # GET /connections
  # GET /connections.json
  def index
    if params[:server_id]
      @connections = Server.find(params[:server_id]).connections.where(:connection_closed => nil)
    elsif params[:user_id]
      @connections = User.find(params[:user_id]).connections.where(:connection_closed => nil)
    else
      @connections = Connection.where(:connection_closed => nil)
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
      format.html { redirect_to server_connection_url(@connection.server, @connection), notice: 'Connection was successfully created.' }
      format.json { render json: @connection, status: :created, location: @connection }
    end
  end

  def new
    @connection = Connection.new
    @connection.user_id = current_user.id
    @connection.server_id = params[:server_id]
    @connection.open_connection(request.remote_ip)

    respond_to do |format|
      if @connection.save
        format.html { redirect_to server_connection_url(@connection.server_id, @connection.id), notice: 'Connection was successfully created.' }
        format.json { render json: @connection, status: :created, location: @connection }
      else
        format.html { render json: @connection.errors, status: :unprocessable_entity }
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end
end
