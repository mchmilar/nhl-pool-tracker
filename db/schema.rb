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

ActiveRecord::Schema.define(version: 20161125172851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string  "name"
    t.integer "op_id_number"
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "lwl_rank"
    t.integer  "lwl_pts"
    t.integer  "pts"
    t.integer  "gp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "team_id"
    t.string   "position"
    t.integer  "draft_pos"
    t.integer  "goals"
    t.integer  "assists"
    t.integer  "points"
    t.integer  "ppg"
    t.integer  "ppp"
    t.integer  "shg"
    t.integer  "shp"
    t.integer  "gwg"
    t.integer  "shots"
    t.decimal  "s_pct"
    t.decimal  "atoi"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "teamFullName"
    t.integer  "gamesPlayed"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "otLosses"
    t.integer  "points"
    t.integer  "regPlusOtWins"
    t.integer  "goalsFor"
    t.integer  "goalsAgainst"
    t.decimal  "ppPctg"
    t.decimal  "pkPctg"
    t.decimal  "shotsForPerGame"
    t.decimal  "shotsAgainstPerGame"
    t.decimal  "faceoffWinPctg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teamAbbrev"
    t.decimal  "goalsAgainstPerGame"
    t.decimal  "goalsForPerGame"
    t.decimal  "pointPctg"
    t.string   "seasonId"
    t.integer  "ties"
    t.integer  "shootoutGamesWon"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
