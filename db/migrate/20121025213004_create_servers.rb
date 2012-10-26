class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :instance_id
      t.references :project
      t.timestamps
    end
  end
end
