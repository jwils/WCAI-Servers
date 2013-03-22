class AddLastPrintedToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :last_printed, :datetime
    add_column :timesheets, :submitted_date, :datetime
    add_column :timesheets, :approved_date, :datetime
  end
end
