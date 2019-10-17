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

ActiveRecord::Schema.define(version: 2019_10_17_134348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_divs", force: :cascade do |t|
    t.string "division_code"
    t.date "activity_date"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_sub_divs", force: :cascade do |t|
    t.integer "activity_div_id"
    t.datetime "activity_time"
    t.string "classification"
    t.decimal "amount", precision: 8, scale: 2
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_type", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "assigned_code", limit: 5
    t.string "activity_type_desc", limit: 100
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "back_trackers", id: :serial, force: :cascade do |t|
    t.integer "back_index", default: 1
    t.string "session_id"
    t.string "mobile_number"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_town_masters", force: :cascade do |t|
    t.string "city_town_name"
    t.integer "region_id"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_categories", force: :cascade do |t|
    t.string "assigned_code"
    t.string "category_name"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_division", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_code", limit: 10
    t.string "assigned_code", limit: 10
    t.string "division_name", limit: 255
    t.string "division_alias", limit: 150
    t.integer "suburb_id"
    t.string "activity_type_code", limit: 10
    t.string "service_label", limit: 150
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "entity_info", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "assigned_code", limit: 10
    t.string "entity_name", limit: 255
    t.string "entity_alias", limit: 255
    t.string "entity_cat_id", limit: 10
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "entity_info_extra", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_code", limit: 10
    t.string "location_address", limit: 150
    t.string "postal_address", limit: 150
    t.string "contact_number", limit: 70
    t.string "web_url", limit: 150
    t.string "contact_email", limit: 150
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "region_masters", force: :cascade do |t|
    t.string "region_name"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_trackers", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.integer "function"
    t.boolean "previous_tracker"
    t.string "page"
    t.integer "mobile_number"
    t.string "ussd_body"
    t.string "msg_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suburb_masters", force: :cascade do |t|
    t.string "suburb_name"
    t.integer "city_town_id"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracker_logs", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "function"
    t.string "page"
    t.string "mobile_number"
    t.string "ussd_body"
    t.string "msg_type"
    t.boolean "previous_tracker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackers", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "function"
    t.string "page"
    t.string "mobile_number"
    t.string "ussd_body"
    t.string "msg_type"
    t.boolean "previous_tracker", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "plan_id"
  end

  create_table "ussd_requests", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "mobile_number"
    t.string "ussd_body"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
