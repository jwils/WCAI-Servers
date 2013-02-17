class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.references :user
      t.date :start_date
      t.boolean :submitted
      t.references :approver

      t.timestamps
    end
    add_index :timesheets, :user_id
    add_index :timesheets, :approver_id
  end
end
