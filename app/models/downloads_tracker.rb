class DownloadsTracker < ActiveRecord::Base
  belongs_to :user
  attr_accessible :file_name, :file_size

  def self.track(user, file)
    tracker = DownloadsTracker.create(:file_name => file.path,
                                           :file_size => file.size)
    tracker.user = user
    tracker.save
  end
end
