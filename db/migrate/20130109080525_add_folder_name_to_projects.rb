class AddFolderNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :folder_name, :string
  end
end
