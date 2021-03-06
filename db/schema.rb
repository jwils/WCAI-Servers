# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130416032815) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "connections", :force => true do |t|
    t.string   "sql_user"
    t.string   "sql_password"
    t.integer  "user_id"
    t.integer  "server_id"
    t.datetime "connection_open"
    t.datetime "connection_closed"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "downloads_trackers", :force => true do |t|
    t.integer  "user_id"
    t.string   "file_name"
    t.integer  "file_size"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  add_index "downloads_trackers", ["project_id"], :name => "index_downloads_trackers_on_project_id"
  add_index "downloads_trackers", ["user_id"], :name => "index_downloads_trackers_on_user_id"

  create_table "project_files", :force => true do |t|
    t.integer  "project_id"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_files", ["project_id"], :name => "index_project_files_on_project_id"

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "project_name"
    t.date     "start_date"
    t.string   "current_state"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "folder_name"
  end

  add_index "projects", ["company_id"], :name => "index_projects_on_company_id"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "servers", :force => true do |t|
    t.string   "instance_id"
    t.integer  "project_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "time_entries", :force => true do |t|
    t.integer  "day"
    t.decimal  "hours_spent"
    t.integer  "timesheet_id"
    t.integer  "project_id"
    t.text     "comment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "time_entries", ["project_id"], :name => "index_time_entries_on_project_id"
  add_index "time_entries", ["timesheet_id"], :name => "index_time_entries_on_timesheet_id"

  create_table "timesheets", :force => true do |t|
    t.integer  "user_id"
    t.date     "start_date"
    t.boolean  "submitted"
    t.integer  "approver_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "last_printed"
    t.datetime "submitted_date"
    t.datetime "approved_date"
  end

  add_index "timesheets", ["approver_id"], :name => "index_timesheets_on_approver_id"
  add_index "timesheets", ["user_id"], :name => "index_timesheets_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "name"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "institution"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
