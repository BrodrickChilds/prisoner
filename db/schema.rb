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

ActiveRecord::Schema.define(:version => 20130319222111) do

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "opp_id"
    t.boolean  "user_strat"
    t.boolean  "opp_strat"
    t.boolean  "complete"
    t.boolean  "seen_bit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "stage_id"
  end

  add_index "games", ["opp_id"], :name => "index_games_on_opp_id"
  add_index "games", ["stage_id"], :name => "index_games_on_stage_id"
  add_index "games", ["user_id"], :name => "index_games_on_user_id"

  create_table "stages", :force => true do |t|
    t.integer  "level"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "score"
    t.integer  "latest_stage"
  end

end
