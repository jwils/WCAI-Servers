class DownloadsTracker < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  def self.track(user, file, project_id)
    tracker = DownloadsTracker.create(:file_name => file.path,
                                      :file_size => file.size)
    tracker.user = user
    tracker.project_id = project_id
    tracker.save
  end
end
