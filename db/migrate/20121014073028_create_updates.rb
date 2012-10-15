class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.references :user
      t.references :job_request
      t.text :description

      t.timestamps
    end
    add_index :updates, :user_id
    add_index :updates, :job_request_id
  end
end
