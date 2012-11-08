class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.references :project
      t.string :file

      t.timestamps
    end
    add_index :project_files, :project_id
  end
end
