class Server < ActiveRecord::Base
  attr_accessible :instance_id
  attr_accessor :instance
  belongs_to :project


  
  after_find :get_instance_object
  before_destroy :delete_instance
  before_save :create_aws_instance

  def start
    self.instance.start
  end

  def stop
    self.instance.stop
  end

  def ready?
   self.instance.ready? 
  end

  def stopped?
    self.instance.state == 'stopped'
  end

  def state
    self.instance.state
  end
  alias :status :state

  def ip_address
    self.instance.ip_address
  end

  def connection_info
    "ip address: " + self.instance.ip_address + " port: " + "12345" +
    "db username: db password"
  end

  private

  def create_aws_instance
    self.instance = FOG_CONNECTION.servers.bootstrap(
                    :image_id => "ami-a29943cb", #change this to custom ami
                    #:type => "whatever type we want",
                    #:security_group => open port for sql
                    :private_key_path =>'~/.ssh/fog',
                    :public_key_path => '~/.ssh/fog.pub',
                    :username => 'ubuntu')
    self.instance_id = self.instance.id
  end

  def delete_instance
    if not self.instance.nil?
      self.instance.destroy
    end
  end

  def get_instance_object
    if self.instance.nil?
      self.instance = FOG_CONNECTION.servers.get(self.instance_id)
    end
  end
end

