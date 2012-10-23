class CreateJobRequests < ActiveRecord::Migration
  def change
    create_table :job_requests do |t|
      t.references :project
      t.references :assignee
      t.references :requester
      t.integer :priority
      t.text :description

      t.timestamps
    end
    add_index :job_requests, :project_id
    add_index :job_requests, :assignee_id
    add_index :job_requests, :requester_id
  end
end
