class AddStatusToJobRequests < ActiveRecord::Migration
  def change
    add_column :job_requests, :status, :string
  end
end
