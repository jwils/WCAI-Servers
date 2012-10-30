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

ActiveRecord::Schema.define(:version => 20121030221938) do

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

  create_table "job_requests", :force => true do |t|
    t.integer  "project_id"
    t.integer  "assignee_id"
    t.integer  "requester_id"
    t.integer  "priority"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "status"
  end

  add_index "job_requests", ["assignee_id"], :name => "index_job_requests_on_assignee_id"
  add_index "job_requests", ["project_id"], :name => "index_job_requests_on_project_id"
  add_index "job_requests", ["requester_id"], :name => "index_job_requests_on_requester_id"

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.date     "start_date"
    t.string   "current_state"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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

  create_table "updates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_request_id"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "updates", ["job_request_id"], :name => "index_updates_on_job_request_id"
  add_index "updates", ["user_id"], :name => "index_updates_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
