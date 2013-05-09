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

ActiveRecord::Schema.define(:version => 20130509031944) do

  create_table "hackathons", :force => true do |t|
    t.string   "eid"
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.string   "location"
    t.text     "description"
    t.integer  "users_id"
    t.integer  "teams_id"
    t.integer  "schedule_items_id"
    t.integer  "proposals_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "hackathons", ["proposals_id"], :name => "index_hackathons_on_proposals_id"
  add_index "hackathons", ["schedule_items_id"], :name => "index_hackathons_on_schedule_items_id"
  add_index "hackathons", ["teams_id"], :name => "index_hackathons_on_teams_id"
  add_index "hackathons", ["users_id"], :name => "index_hackathons_on_users_id"

  create_table "hackathons_users", :id => false, :force => true do |t|
    t.integer "hackathon_id"
    t.integer "user_id"
  end

  add_index "hackathons_users", ["hackathon_id", "user_id"], :name => "index_hackathons_users_on_hackathon_id_and_user_id"
  add_index "hackathons_users", ["user_id", "hackathon_id"], :name => "index_hackathons_users_on_user_id_and_hackathon_id"

  create_table "proposals", :force => true do |t|
    t.string   "desc"
    t.string   "name"
    t.string   "skills"
    t.integer  "team_id"
    t.integer  "hackathon_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "proposals", ["hackathon_id"], :name => "index_proposals_on_hackathon_id"
  add_index "proposals", ["team_id"], :name => "index_proposals_on_team_id"

  create_table "schedule_items", :force => true do |t|
    t.string   "label"
    t.integer  "hackathon_id"
    t.datetime "start_time"
    t.string   "icon_class"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "schedule_items", ["hackathon_id"], :name => "index_schedule_items_on_hackathon_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "hackathon_id"
    t.integer  "users_id"
    t.integer  "proposals_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "description"
  end

  add_index "teams", ["hackathon_id"], :name => "index_teams_on_hackathon_id"
  add_index "teams", ["proposals_id"], :name => "index_teams_on_proposals_id"
  add_index "teams", ["users_id"], :name => "index_teams_on_users_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "github_email"
    t.string   "tags"
    t.boolean  "signed_up"
    t.integer  "hackathons_id"
    t.integer  "teams_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["hackathons_id"], :name => "index_users_on_hackathons_id"
  add_index "users", ["teams_id"], :name => "index_users_on_teams_id"

end
