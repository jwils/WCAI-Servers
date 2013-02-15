class DownloadsTracker < ActiveRecord::Base
  belongs_to :user
  attr_accessible :file_name, :file_size
end
