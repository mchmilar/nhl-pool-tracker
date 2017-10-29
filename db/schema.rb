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

ActiveRecord::Schema.define(version: 20171029124351) do

  create_table "games", force: :cascade do |t|
    t.integer  "nhl_game_id",  limit: 4
    t.string   "link",         limit: 255
    t.string   "game_type",    limit: 255
    t.integer  "season",       limit: 4
    t.datetime "game_date"
    t.integer  "away_team_id", limit: 4
    t.integer  "home_team_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "games", ["away_team_id"], name: "fk_rails_5b075ea244", using: :btree
  add_index "games", ["home_team_id"], name: "fk_rails_0b3e4ed788", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.integer "op_id_number", limit: 4
  end

  create_table "player_stat_histories", force: :cascade do |t|
    t.integer  "player_id",  limit: 4
    t.integer  "team_id",    limit: 4
    t.integer  "pts",        limit: 4
    t.integer  "gp",         limit: 4
    t.integer  "goals",      limit: 4
    t.integer  "assists",    limit: 4
    t.integer  "ppg",        limit: 4
    t.integer  "shg",        limit: 4
    t.integer  "shp",        limit: 4
    t.integer  "shots",      limit: 4
    t.decimal  "s_pct",                precision: 10
    t.decimal  "atoi",                 precision: 10
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "ppp",        limit: 4
    t.date     "date"
  end

  add_index "player_stat_histories", ["player_id"], name: "index_player_stat_histories_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "lwl_rank",   limit: 4,                  default: 999
    t.integer  "lwl_pts",    limit: 4,                  default: 0
    t.integer  "pts",        limit: 4,                  default: 0
    t.integer  "gp",         limit: 4,                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",   limit: 4
    t.string   "team_id",    limit: 255
    t.string   "position",   limit: 255
    t.integer  "draft_pos",  limit: 4
    t.integer  "goals",      limit: 4,                  default: 0
    t.integer  "assists",    limit: 4,                  default: 0
    t.integer  "points",     limit: 4,                  default: 0
    t.integer  "ppg",        limit: 4,                  default: 0
    t.integer  "ppp",        limit: 4,                  default: 0
    t.integer  "shg",        limit: 4,                  default: 0
    t.integer  "shp",        limit: 4,                  default: 0
    t.integer  "gwg",        limit: 4,                  default: 0
    t.integer  "shots",      limit: 4,                  default: 0
    t.decimal  "s_pct",                  precision: 10, default: 0
    t.decimal  "atoi",                   precision: 10, default: 0
  end

  create_table "teams", force: :cascade do |t|
    t.string   "teamFullName",        limit: 255
    t.integer  "gamesPlayed",         limit: 4
    t.integer  "wins",                limit: 4
    t.integer  "losses",              limit: 4
    t.integer  "otLosses",            limit: 4
    t.integer  "points",              limit: 4
    t.integer  "regPlusOtWins",       limit: 4
    t.integer  "goalsFor",            limit: 4
    t.integer  "goalsAgainst",        limit: 4
    t.decimal  "ppPctg",                          precision: 10
    t.decimal  "pkPctg",                          precision: 10
    t.decimal  "shotsForPerGame",                 precision: 10
    t.decimal  "shotsAgainstPerGame",             precision: 10
    t.decimal  "faceoffWinPctg",                  precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teamAbbrev",          limit: 255
    t.decimal  "goalsAgainstPerGame",             precision: 10
    t.decimal  "goalsForPerGame",                 precision: 10
    t.decimal  "pointPctg",                       precision: 10
    t.string   "seasonId",            limit: 255
    t.integer  "ties",                limit: 4
    t.integer  "shootoutGamesWon",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_token",  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
end
