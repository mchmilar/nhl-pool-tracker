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

ActiveRecord::Schema.define(version: 20161023125704) do

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
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "gp"
    t.integer  "w"
    t.integer  "l"
    t.integer  "ot"
    t.integer  "p"
    t.integer  "row"
    t.decimal  "p_pct"
    t.integer  "gf"
    t.integer  "ga"
    t.decimal  "pp_pct"
    t.decimal  "pk_pct"
    t.decimal  "shots_for_gp"
    t.decimal  "shots_against_gp"
    t.decimal  "fow_pct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
