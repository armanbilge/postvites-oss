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

ActiveRecord::Schema.define(version: 20170220124437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendee_keywords", force: :cascade do |t|
    t.integer  "attendee_id"
    t.integer  "keyword_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["attendee_id"], name: "index_attendee_keywords_on_attendee_id", using: :btree
    t.index ["keyword_id"], name: "index_attendee_keywords_on_keyword_id", using: :btree
  end

  create_table "attendees", force: :cascade do |t|
    t.string   "last"
    t.string   "first"
    t.string   "email"
    t.string   "affiliation"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["conference_id"], name: "index_attendees_on_conference_id", using: :btree
  end

  create_table "conferences", force: :cascade do |t|
    t.string   "name"
    t.integer  "invite_limit",       default: 3
    t.integer  "poster_limit",       default: 5
    t.boolean  "presenters_emailed", default: false
    t.boolean  "attendees_emailed",  default: false
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "logo_url",           default: ""
    t.date     "deadline"
    t.string   "email"
    t.string   "time_zone",          default: "UTC"
    t.string   "hashtag"
    t.index ["user_id"], name: "index_conferences_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "attendee_id"
    t.integer  "presenter_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "include_email"
    t.text     "message"
    t.index ["attendee_id"], name: "index_invitations_on_attendee_id", using: :btree
    t.index ["presenter_id"], name: "index_invitations_on_presenter_id", using: :btree
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "name"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["conference_id"], name: "index_keywords_on_conference_id", using: :btree
  end

  create_table "presenters", force: :cascade do |t|
    t.string   "last"
    t.string   "first"
    t.string   "email"
    t.string   "affiliation"
    t.string   "title"
    t.string   "session"
    t.string   "location"
    t.string   "secret"
    t.integer  "conference_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "number"
    t.text     "abstract"
    t.date     "session_day"
    t.time     "session_start"
    t.time     "session_end"
    t.index ["conference_id"], name: "index_presenters_on_conference_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attendee_keywords", "attendees"
  add_foreign_key "attendee_keywords", "keywords"
  add_foreign_key "attendees", "conferences"
  add_foreign_key "conferences", "users"
  add_foreign_key "invitations", "attendees"
  add_foreign_key "invitations", "presenters"
  add_foreign_key "keywords", "conferences"
  add_foreign_key "presenters", "conferences"
end
