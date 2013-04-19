# Definition is implicit of many methods. Cancan handles resources and access.
# Below are the defined paths and routes:
#
# GET /servers/:server_id/connections
# def index
#
#
# GET /servers/:server_id/connections/1
# def show
#
class ConnectionsController < ApplicationController
  load_and_authorize_resource :server
  load_and_authorize_resource :connection, :through => :server

  # DELETE /servers/:server_id/connections/1
  def destroy
    @connection.close_connection
    respond_to do |format|
      format.html { redirect_to server_connections_url(@connection.server), notice: 'Connection was successfully closed.' }
      format.json { render json: @connection, status: :created, location: @connection }
    end
  end

  # GET /servers/:server_id/connections/new
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
