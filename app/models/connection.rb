class Connection < ActiveRecord::Base
  belongs_to :user, :server

  attr_accessible  :user_id, :server_id
  attr_protected :sql_password, :sql_user, :connection_closed, :connection_open

  before_create :open_connection

  def generate_user_password
  	self.sql_user = Digest::SHA1.hexdigest("--#{Time.now.to_s}")[0,6]
  	self.sql_password = Digest::SHA1.hexdigest("--#{Time.now.to_s}")[0,6]
  	
  end

  def open_connection(ip_address)
  	generate_user_password
  	#return false if connection can not be opened to db

		privileges = "ALL PRIVILEGES" #options (CREATE DROP DELETE INSERT SELECT UPDATE)
		full_user = "'#{self.sql_user}'@'#{ip_address}'"

		self.server.ssh(sql_cmd("GRANT #{privileges} ON *.* TO #{full_user}"
			+ " IDENTIFIED BY '#{self.sql_password}';"))
		self.connection_open = DateTime.now
  end

  def close_connection
  	self.server.ssh(sql_cmd("DROP USER 'demo'@'localhost';")) #add save full user object
  	self.connection_closed = DateTime.now
  end

  private
  def sql_cmd(comamnd)
  	'mysql -uroot -p***** -e "' + command + '"'
  end
end
