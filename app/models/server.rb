class Server < ActiveRecord::Base
  attr_accessible :image_id
  belongs_to :project
  def start

  end

  def stop

  end

  def status

  end
end
