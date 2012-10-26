class Server < ActiveRecord::Base
  attr_accessible :instance_id
  attr_protected :server
  belongs_to :project
  
  after_find :get_instance_object
  before_destroy :delete_instance
  before_save :create_aws_instance

  def start
    self.server.start
  end

  def stop
    self.server.stop
  end

  def ready?
   self.server.ready? 
  end

  def state
    self.state
  end

  private

  def create_aws_instance
    self.server = FOG_CONNECTION.servers.bootstrap(
                    :image_id => "ami-a29943cb", #change this to custom ami
                    #:type => "whatever type we want"
                    :private_key_path =>'~/.ssh/fog',
                    :public_key_path => '~/.ssh/fog.pub',
                    :username => 'ubuntu')
    self.instance_id = self.server.id
  end

  def delete_instance
    self.server.destroy
  end

  def get_instance_object
    self.server = FOG_CONNECTION.servers.get(self.instance_id)
  end
end

