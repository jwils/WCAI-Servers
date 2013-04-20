# This tracker is used to track s3 downloads for users.
class DownloadsTracker < ActiveRecord::Base
  attr_accessible :file_name, :file_size, :project_id

  belongs_to :user
  belongs_to :project

  # Given an S3File, user, and project_id we create and save a tracker.
  def self.track(user, file, project_id)
    tracker = DownloadsTracker.create(:file_name => file.path,
                                      :file_size => file.size,
                                      :project_id => project_id)
    tracker.user = user
    tracker.save
  end
end
