class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :user
      t.references :company
      t.date :start_date
      t.string :current_state
      t.text :description

      t.timestamps
    end
    add_index :projects, :user_id
    add_index :projects, :company_id
  end
end
