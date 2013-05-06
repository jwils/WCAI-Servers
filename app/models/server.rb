class Server < ActiveRecord::Base
  MYSQL_CMD_PREFIX = "mysql -uroot -p#{Settings.mysql_root_password} -e "
  CMD_ON_SERVER_START = "sudo apt-get update && sudo apt-get upgrade -y"

  attr_accessor :instance
  attr_accessible :instance_id, :project_id

  belongs_to :project
  has_many :connections

  after_find :get_instance_object
  before_destroy :delete_instance

  def configure(schema_name)
    create_aws_instance
    exec_sql("create SCHEMA #{schema_name};")
    stop
  end

  def ssh(commands)
    start
    wait_for_ready

    retry_count = 0
    begin
      logger.info self.instance.ssh(commands)[0].stdout
    rescue => error
      sleep(5)
      retry_count += 1
      logger.info "Connection failed retrying #{5 - retry_count} more times"
      retry if retry_count < 5
      logger.error "Failed to connect to server after five attempts. Backtrace:\n"
      logger.error error.backtrace
    end

  end

  def download_file(file_path)
    self.instance.scp_download(file_path, Rails.root.join("public", "ec2_files"))
  end

  def get_directory(directory)
    file = Ec2File.new
    file.path = directory
    file.children = list_files_in_directory(directory)
    file
  end

  def get_local_files
    get_directory('/var/files/') if ready?
  end

  def create_aws_instance
    self.instance = FOG_CONNECTION.servers.bootstrap(
        :image_id => Settings.image_id, #"ami-7539b41c",
        :flavor_id => "m1.large",
        :private_key_path => Settings.keypair_path,
        :public_key_path => Settings.keypair_path + '.pub',
        :username => 'ubuntu')

    self.instance_id = self.instance.id
    self.save

    self.ssh(CMD_ON_SERVER_START)
  end

  def open_connection(user, ip_address)
    connection = Connection.create(user, self, ip_address)
    exec_sql(connection.sql_user_creation_cmd)
    connection
  end

  def check_uptime
    unless stopped?
      if connections.length == 0
        UserMailer.send_email_to_list(nil, User.with_role(:admin), "Server on without any connections",
                                      "There appears to be a server turned on without any open connections. Please shut it down manually.").deliver
      end
      if connections.any? { |connection| connection.connection_open + 3.hours < DateTime.now }
        InstanceReportMailer.uptime_report(User.with_role(:admin), self).deliver
      end
    end
  end

  def exec_sql(cmd)
    ssh(MYSQL_CMD_PREFIX + "\"#{cmd}\"")
  end

  def has_open_connections?
    connections.length != 0
  end

  # == Instance status commands

  def ready?
    self.instance.ready?
  end

  def start
    self.instance.start
  end

  def stop
    self.ssh("sudo rm -rf /var/files/*")
    self.instance.stop
  end

  def wait_for_ready
    self.instance.wait_for { ready? }
    self.instance.wait_for { !public_ip_address.nil? }
    sleep(5)
  end

  def stopped?
    self.state == 'stopped' || self.state == 'terminated'
  end

  def state
    if self.instance.nil?
      'terminated'
    else
      self.instance.state
    end
  end

  alias :status :state

  def ip_address
    self.instance.public_ip_address
  end

  # nicer URLs
  def to_param
    "#{id} #{project.name}".parameterize
  end

  private

  def delete_instance
    unless self.instance.nil?
      self.instance.destroy
    end
  end

  def get_instance_object
    self.instance = FOG_CONNECTION.servers.get(self.instance_id)

    unless self.instance.nil?
      self.instance.private_key_path = Settings.keypair_path
      self.instance.public_key_path = Settings.keypair_path + '.pub'
      self.instance.username = 'ubuntu'
    end
  end

  def list_files_in_directory(directory)
    raw_files_string = self.instance.ssh("ls -l #{directory}")[0].stdout
    raw_files_string.split("\r\n")[1..-1].collect do |file_string|

      file = Ec2File.create(directory, file_string)
      if file.is_directory?
        file.children= list_files_in_directory(file.path)
      end
      file
    end
  end

  #
  # This function is not currently used, but it might be useful to create users through
  # a remote mysql connection instead of sshing into the instance.
  #
  def create_mysql_connection
    client = Mysql2::Client.new(:host => ip_address, :username => "root", :password => Settings.mysql_root_password)
    client.query("")
  end
end

