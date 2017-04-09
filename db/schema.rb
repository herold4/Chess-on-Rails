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

ActiveRecord::Schema.define(version: 20170409224322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "moves_completed", default: 0, null: false
    t.jsonb    "positions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moves", force: :cascade do |t|
    t.integer  "game_id",                null: false
    t.integer  "ordinal",    default: 0, null: false
    t.integer  "player_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moves", ["game_id", "ordinal"], name: "index_moves_on_game_id_and_ordinal", unique: true, using: :btree

  create_table "moves_players", id: false, force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "move_id",   null: false
  end

  add_index "moves_players", ["move_id", "player_id"], name: "index_moves_players_on_move_id_and_player_id", using: :btree
  add_index "moves_players", ["player_id", "move_id"], name: "index_moves_players_on_player_id_and_move_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string  "name",            null: false
    t.integer "current_game_id"
    t.string  "session_token"
  end

end
