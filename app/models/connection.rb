class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :server

  attr_accessible  :user_id, :server_id
  attr_protected :sql_password, :sql_user, :connection_closed, :connection_open

  def generate_user_password(ip_address)
    self.sql_user = "'#{Digest::SHA1.hexdigest("--#{Time.now.to_s}")[0,6]}'@'#{ip_address}'"
  	self.sql_password = Digest::SHA1.hexdigest("--#{Time.now.to_s}#{ip_address}")[0,6]
  	
  end

  def open_connection(ip_address)
    self.server.start
    self.server.wait_for_ready

  	generate_user_password(ip_address)

		privileges = "ALL PRIVILEGES" #options (CREATE DROP DELETE INSERT SELECT UPDATE)
    cmd = "GRANT #{privileges} ON *.* TO #{self.sql_user}  IDENTIFIED BY '#{self.sql_password}';"

		self.server.ssh(sql_cmd(cmd))
		self.connection_open = DateTime.now
  end

  def close_connection
  	self.server.ssh(sql_cmd("DROP USER #{self.sql_user};")) #add save full user object
  	self.connection_closed = DateTime.now
    self.save
    if self.server.open_connections.length == 0
      self.server.stop
    end
  end

  private
  def sql_cmd(cmd)
  	"mysql -uroot -p#{Settings.mysql_root_password} -e \"" + cmd + '"'
  end
end
