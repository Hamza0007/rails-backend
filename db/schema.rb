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

ActiveRecord::Schema.define(version: 20170528102428) do

  create_table "teams", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "country",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "age",        limit: 4
    t.decimal  "average",                precision: 5, scale: 2
    t.string   "role",       limit: 255,                         default: "player"
    t.string   "status",     limit: 255,                         default: "enabled"
    t.integer  "matches",    limit: 4
    t.integer  "team_id",    limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  add_foreign_key "users", "teams"
end
