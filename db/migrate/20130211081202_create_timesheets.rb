class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.references :user
      t.date :start_date
      t.boolean :submitted
      t.boolean :approved

      t.timestamps
    end
    add_index :timesheets, :user_id
  end
end
