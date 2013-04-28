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

ActiveRecord::Schema.define(:version => 20130428120101) do

  create_table "attendees", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "buddy_data", :force => true do |t|
    t.string   "name"
    t.string   "idea"
    t.string   "skills"
    t.boolean  "isIdea"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "git_data", :force => true do |t|
    t.string   "user"
    t.string   "repo"
    t.string   "time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "schedule_items", :force => true do |t|
    t.string   "name"
    t.string   "iconUrl"
    t.string   "time"
    t.boolean  "isMajor"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
