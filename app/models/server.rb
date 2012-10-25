class Server < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :image_id
  has_one :project
end
