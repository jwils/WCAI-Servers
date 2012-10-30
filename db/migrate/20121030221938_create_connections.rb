class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :sql_user
      t.string :sql_password
      t.references :user
      t.references :server
      t.datetime :connection_open
      t.datetime :connection_closed

      t.timestamps
    end
  end
end
