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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141003164734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "turn"
    t.string   "session_id"
    t.string   "white_moved"
    t.string   "black_moved"
  end

  create_table "players", force: true do |t|
    t.integer  "game_id"
    t.boolean  "white"
    t.string   "captured"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
