class CreateDownloadsTrackers < ActiveRecord::Migration
  def change
    create_table :downloads_trackers do |t|
      t.references :user
      t.string :file_name
      t.integer :file_size

      t.timestamps
    end
    add_index :downloads_trackers, :user_id
  end
end
