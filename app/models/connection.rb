class Connection < ActiveRecord::Base
  default_scope { where(:connection_closed => nil) }

  belongs_to :user
  belongs_to :server

  attr_accessible :user_id, :server_id
  attr_protected :sql_password, :sql_user, :connection_closed, :connection_open

  def self.create(user, server, ip_address)
    connection = Connection.new
    connection.user_id = user.id
    connection.server_id = server.id
    connection.generate_user_password(ip_address)
    connection.save
    connection
  end

  def access_cmd
    "mysql --host=#{server.ip_address} -u#{self.sql_user.split("'")[1]} -p#{sql_password}"
  end

  def username
    self.sql_user.split("'")[1]
  end

  def close_connection
    self.server.exec_sql("DROP USER #{self.sql_user};")
    self.connection_closed = DateTime.now
    self.save

    unless self.server.has_open_connections?
      self.server.stop
    end
  end

  def connection_open_str
    time = connection_open
    if time.today?
      time.to_s(:clock_time)
    else
      time
    end
  end

  def connection_closed_str
    time = connection_closed
    if time.nil?
      "Connection is Open"
    elsif time.today?
      time.to_s(:clock_time)
    else
      time
    end
  end

  def sql_user_creation_cmd
    self.connection_open = DateTime.now
    self.save
    privileges = "ALL PRIVILEGES" #options (CREATE DROP DELETE INSERT SELECT UPDATE)
    "GRANT #{privileges} ON *.* TO #{sql_user}  IDENTIFIED BY '#{sql_password}';"
  end

  def generate_user_password(ip_address)
    self.sql_user = "'#{Digest::SHA1.hexdigest("--#{Time.now.to_s.split(//).sort_by { rand }.join}").split("").shuffle.join[0, 6]}'@'#{ip_address}'"
    self.sql_password = Digest::SHA1.hexdigest("--#{Time.now.to_s}#{ip_address}").split("").shuffle.join[0, 6]
  end
end
