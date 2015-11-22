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

ActiveRecord::Schema.define(version: 20151114075534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.string   "last"
    t.string   "first"
    t.string   "email"
    t.string   "affiliation"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "attendees", ["conference_id"], name: "index_attendees_on_conference_id", using: :btree

  create_table "attendees_presenters", id: false, force: :cascade do |t|
    t.integer "attendee_id"
    t.integer "presenter_id"
  end

  add_index "attendees_presenters", ["attendee_id"], name: "index_attendees_presenters_on_attendee_id", using: :btree
  add_index "attendees_presenters", ["presenter_id"], name: "index_attendees_presenters_on_presenter_id", using: :btree

  create_table "conferences", force: :cascade do |t|
    t.string   "name"
    t.integer  "invite_limit",       default: 3
    t.integer  "poster_limit",       default: 5
    t.boolean  "presenters_emailed", default: false
    t.boolean  "attendees_emailed",  default: false
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "conferences", ["user_id"], name: "index_conferences_on_user_id", using: :btree

  create_table "presenters", force: :cascade do |t|
    t.string   "last"
    t.string   "first"
    t.string   "email"
    t.string   "affiliation"
    t.string   "title"
    t.text     "abstract"
    t.string   "session"
    t.string   "location"
    t.string   "secret_id"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "presenters", ["conference_id"], name: "index_presenters_on_conference_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendees", "conferences"
  add_foreign_key "conferences", "users"
  add_foreign_key "presenters", "conferences"
end
