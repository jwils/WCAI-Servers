class Connection < ActiveRecord::Base
  attr_accessible :connection_closed, :connection_open, :references, :references, :sql_password, :sql_user, :user_id, :server_id
end
