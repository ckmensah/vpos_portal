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

ActiveRecord::Schema.define(version: 2019_11_11_180204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_divs", force: :cascade do |t|
    t.string "division_code"
    t.date "activity_date"
    t.text "comment"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
    t.string "activity_div_desc", limit: 150
  end

  create_table "activity_sub_div_class", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.string "class_desc", limit: 100
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "activity_sub_divs", force: :cascade do |t|
    t.integer "activity_div_id"
    t.time "activity_time"
    t.integer "classification"
    t.decimal "amount", precision: 8, scale: 2
    t.text "comment"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "activity_type", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "assigned_code", limit: 5
    t.string "activity_type_desc", limit: 100
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "assigned_service_code", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.string "service_code", limit: 10
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
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

  create_table "division_activity_lov", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "activity_code", limit: 10
    t.string "division_code", limit: 10
    t.string "lov_desc", limit: 150
    t.string "comment", limit: 255
    t.integer "user_id"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "entity_categories", force: :cascade do |t|
    t.string "assigned_code"
    t.string "category_name"
    t.text "comment"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
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
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
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
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
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
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "entity_wallet_configs", force: :cascade do |t|
    t.string "division_code"
    t.integer "service_id"
    t.string "secret_key"
    t.string "client_key"
    t.text "comment"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "ussd_activity_plans_temps", id: :serial, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "activity_plan_index"
    t.string "activity_plan_id"
    t.string "activity_plan"
    t.string "activity_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_activity_sub_plans_temps", id: :serial, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "activity_plan_id"
    t.string "activity_plan"
    t.string "activity_date"
    t.string "activity_sub_plan_index"
    t.string "activity_sub_plan_id"
    t.string "activity_time"
    t.string "classification"
    t.string "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_back_trackers", id: :integer, default: -> { "nextval('back_trackers_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "back_index", default: 1
    t.string "session_id"
    t.string "mobile_number"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ussd_lov_temps", id: :integer, default: -> { "nextval('lov_temps_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "lov_id"
    t.string "lov_desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.string "lov_index"
  end

  create_table "ussd_more_algos", force: :cascade do |t|
    t.string "session_id"
    t.string "function"
    t.string "page"
    t.string "mobile_number"
    t.string "ussd_body"
    t.integer "the_up"
    t.integer "the_down"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_requests", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "mobile_number"
    t.string "ussd_body"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ussd_service_codes", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "mobile_number"
    t.string "service_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_session_trackers", id: :integer, default: -> { "nextval('session_trackers_id_seq'::regclass)" }, force: :cascade do |t|
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

  create_table "ussd_tracker_activity_temps", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.string "mobile_number"
    t.string "activity_type"
    t.string "service_code"
    t.string "entity_div_code"
    t.string "entity_div_name"
    t.string "service_label"
    t.string "activity_type_menu"
    t.string "activity_type_sub_menu"
    t.string "activity_type_lov_id"
    t.string "activity_type_lov_desc"
    t.string "reference"
    t.string "amount"
    t.string "activity_purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.string "fullname"
    t.string "month_code"
    t.string "month_full"
  end

  create_table "ussd_tracker_logs", id: :integer, default: -> { "nextval('tracker_logs_id_seq'::regclass)" }, force: :cascade do |t|
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

  create_table "ussd_trackers", id: :integer, default: -> { "nextval('trackers_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "session_id"
    t.string "function"
    t.string "page"
    t.string "mobile_number"
    t.string "ussd_body"
    t.string "msg_type"
    t.boolean "previous_tracker", default: false
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
