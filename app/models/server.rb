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
    self.connections.where(:connection_closed => nil)
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
    puts commands
    retry_count = 0
    begin
      puts self.instance.ssh(commands)[0].stdout
    rescue
      sleep(5)
      retry_count += 1
      logger.info "Connection failed retrying #{5 - retry_count} more times"
      retry if retry_count < 5
      logger.error "Failed to connect to server after five attempts"
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
                    :image_id => "ami-7539b41c",
                    :flavor_id => "m1.large",
                    :private_key_path =>Settings.keypair_path + 'fog',
                    :public_key_path => Settings.keypair_path + 'fog.pub',
                    :username => 'ubuntu')

    self.instance_id = self.instance.id
    self.save

    self.wait_for_ready
    sleep(10)
    self.ssh("sudo apt-get update && sudo apt-get upgrade -y")
    self.ssh("sudo debconf-set-selections <<< 'mysql-server-<version> mysql-server/root_password password" +
                 " #{Settings.mysql_root_password}'; sudo debconf-set-selections <<< 'mysql-server-<version>" +
                 " mysql-server/root_password_again password #{Settings.mysql_root_password}'; "+
                 "sudo apt-get -y install xfsprogs mysql-server")

    self.ssh("cd /etc/mysql/; sudo rm my.cnf; sudo wget http://wcai-web.wharton.upenn.edu/my.cnf")
    self.stop
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
end

