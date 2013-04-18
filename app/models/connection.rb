class Connection < ActiveRecord::Base
  default_scope { where(:connection_closed => nil) }

  belongs_to :user
  belongs_to :server

  attr_accessible :user_id, :server_id
  attr_protected :sql_password, :sql_user, :connection_closed, :connection_open

  def generate_user_password(ip_address)
    self.sql_user = "'#{Digest::SHA1.hexdigest("--#{Time.now.to_s.split(//).sort_by { rand }.join}").split("").shuffle.join[0, 6]}'@'#{ip_address}'"
    self.sql_password = Digest::SHA1.hexdigest("--#{Time.now.to_s}#{ip_address}").split("").shuffle.join[0, 6]

  end

  def access_cmd
    "mysql --host=#{server.ip_address} -u#{self.sql_user.split("'")[1]} -p#{sql_password}"
  end

  def username
    self.sql_user.split("'")[1]
  end

  def close_connection
    self.server.exec_sql("DROP USER #{self.sql_user};") #add save full user object
    self.connection_closed = DateTime.now
    self.save
    if self.server.open_connections.length == 0
      self.server.stop
    end
  end

  def connection_open_str
    time = connection_open
    if time == Date.today
      time.to_s(:time)
    else
      time
    end
  end

  def connection_closed_str
    time = connection_closed
    if time.nil?
      "Connection is Open"
    elsif time == Date.today
      time.to_s(:time)
    else
      time
    end
  end
end
