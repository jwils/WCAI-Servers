class Server < ActiveRecord::Base
  attr_accessible :instance_id, :project_id
  attr_accessor :instance
  belongs_to :project
  has_many :connections
  
  after_find :get_instance_object
  before_destroy :delete_instance

  def start
    self.instance.start
  end

  def configure(schema_name)
    create_aws_instance
    ssh("mysql -uroot -p#{Settings.mysql_root_password} -e \"" + "create SCHEMA #{schema_name};" + '"')
    stop
  end

  def stop
    self.instance.stop
  end

  def ready?
   self.instance.ready? 
  end

  def wait_for_ready
    self.instance.wait_for { ready? }
    self.instance.wait_for { !public_ip_address.nil?}
    sleep(5)
  end

  def stopped?
    self.instance.state == 'stopped' || self.instance.state == 'terminated'
  end

  def state
    if self.instance.nil?
      'Terminated'
    else
      self.instance.state
    end
  end

  alias :status :state

  def open_connections
    self.connections.only_open
  end

  def ip_address
    self.instance.public_ip_address
  end

  def connection_info
    "ip address: " + self.instance.public_ip_address + " port: " + "12345" +
    "db username: db password"
  end

  def ssh(commands)
    get_instance_object
    logger.info "Executing command on server: " + commands
    retry_count = 0
    begin
      logger.info self.instance.ssh(commands)[0].stdout
    rescue
      sleep(5)
      retry_count += 1
      logger.info "Connection failed retrying #{5 - retry_count} more times"
      retry if retry_count < 5
      logger.error "Failed to connect to server after five attempts"
    end

  end

  def download_file(file_path)
    cmd = "scp -oStrictHostKeyChecking=no -i#{Settings.keypair_path}fog ubuntu@#{instance.public_ip_address}:#{file_path} #{Rails.root.join("public","ec2_files")}"
    system(cmd)
  end

  def get_files(directory)
    file = Ec2File.new
    file.path = directory
    file.children = list_files_in_directory(directory)
    file
  end

  def create_aws_instance
    self.instance = FOG_CONNECTION.servers.bootstrap(
                    :image_id => "ami-c0ccaaa9", #"ami-7539b41c",
                    :flavor_id => "m1.large",
                    :private_key_path =>Settings.keypair_path + 'fog',
                    :public_key_path => Settings.keypair_path + 'fog.pub',
                    :username => 'ubuntu')

    self.instance_id = self.instance.id
    self.save

    self.wait_for_ready
    sleep(10)
    self.ssh("sudo apt-get update && sudo apt-get upgrade -y")
  end

  def open_connection(user, ip_address)
    Connection.open_connection(user.id, id, ip_address)
  end

  def check_uptime
    unless stopped?
      if open_connections.length == 0
        UserMailer.send_email_to_list(nil, User.with_role(:admin),"Server on without any connections",
                                      "There appears to be a server turned on without any open connections. Please shut it down manually.").deliver
      end
      open_connections.each do |connection|
        if connection.connection_open + 3.hours < DateTime.now
          InstanceReportMailer.uptime_report(User.with_role(:admin), server).deliver
        end
      end
    end
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
      self.instance.private_key_path = Settings.keypair_path + 'fog'
      self.instance.public_key_path = Settings.keypair_path + 'fog.pub'
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
end

