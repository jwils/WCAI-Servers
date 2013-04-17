class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :server

  attr_accessible :user_id, :server_id
  attr_protected :sql_password, :sql_user, :connection_closed, :connection_open

  scope :only_open, where(:connection_closed => nil)

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

  def open_connection(ip_address)
    self.server.start
    self.server.wait_for_ready

    generate_user_password(ip_address)

    privileges = "ALL PRIVILEGES" #options (CREATE DROP DELETE INSERT SELECT UPDATE)
    cmd = "GRANT #{privileges} ON *.* TO #{self.sql_user}  IDENTIFIED BY '#{self.sql_password}';"

    self.server.ssh(sql_cmd(cmd))
    self.connection_open = DateTime.now
    self
  end

  def self.open_connection(user_id, server_id, ip_address)
    connection = Connection.new
    connection.user_id = user_id
    connection.server_id = server_id
    connection.open_connection(ip_address)
  end

  def close_connection
    self.server.ssh(sql_cmd("DROP USER #{self.sql_user};")) #add save full user object
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

  private
  def sql_cmd(cmd)
    "mysql -uroot -p#{Settings.mysql_root_password} -e \"" + cmd + '"'
  end
end
