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

ActiveRecord::Schema.define(version: 2019_01_14_160041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "start_dt", null: false
    t.datetime "end_dt", null: false
    t.bigint "coach_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_appointments_on_coach_id"
    t.index ["end_dt"], name: "index_appointments_on_end_dt"
    t.index ["start_dt"], name: "index_appointments_on_start_dt"
  end

  create_table "availabilities", force: :cascade do |t|
    t.datetime "start_dt", null: false
    t.datetime "end_dt", null: false
    t.bigint "coach_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coach_id"], name: "index_availabilities_on_coach_id"
    t.index ["end_dt"], name: "index_availabilities_on_end_dt"
    t.index ["start_dt"], name: "index_availabilities_on_start_dt"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name", null: false
    t.integer "utc_offset", null: false
    t.integer "availabilities_count", default: 0, null: false
    t.integer "appointments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "appointments", "coaches"
  add_foreign_key "availabilities", "coaches"
end
