class AddServerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :server_id, :string
  end
end
