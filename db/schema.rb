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

ActiveRecord::Schema.define(:version => 20130501075925) do

  create_table "hackathons", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "start"
    t.string   "end"
    t.string   "location"
    t.string   "scheduleItems"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "proposals", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "skills"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "proposals", ["team_id"], :name => "index_proposals_on_team_id"

  create_table "schedule_items", :force => true do |t|
    t.string   "label"
    t.string   "start_time"
    t.integer  "hackathon_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "schedule_items", ["hackathon_id"], :name => "index_schedule_items_on_hackathon_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "hackathon_id"
    t.integer  "users_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "teams", ["hackathon_id"], :name => "index_teams_on_hackathon_id"
  add_index "teams", ["users_id"], :name => "index_teams_on_users_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
