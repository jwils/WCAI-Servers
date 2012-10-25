class AddServerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :server_id, :integer
    add_index :projects, :server_id
  end
end
