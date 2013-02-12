class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.date :date
      t.decimal :hours_spent
      t.references :timesheet
      t.references :project
      t.text :comment

      t.timestamps
    end
    add_index :time_entries, :timesheet_id
    add_index :time_entries, :project_id
  end
end
