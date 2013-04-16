class AddProjectIdToDownloadsTracker < ActiveRecord::Migration
  def change
    add_column :downloads_trackers, :project_id, :integer
    add_index :downloads_trackers, :project_id

    DownloadsTracker.all.each do |tracker|
      tracker.file_name = S3File.decode(tracker.file_name)
      tracker.project_id = Project.find_by_folder_name(tracker.file_name.split('/')[0]).id
      tracker.save
    end
  end
end
