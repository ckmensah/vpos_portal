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

ActiveRecord::Schema.define(version: 2020_01_28_110840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_category", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "assigned_code", limit: 10
    t.string "activity_cat_desc", limit: 155
    t.text "image_data"
    t.string "image_path", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
  end

  create_table "activity_category_div", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "division_code", limit: 10
    t.integer "activity_category_id"
    t.integer "activity_div_cat_id"
    t.string "category_div_desc", limit: 155
    t.string "comment", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
  end

  create_table "activity_div_cat", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "division_code", limit: 10
    t.string "div_cat_desc", limit: 100
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
  end

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
    t.integer "activity_fixture_id"
  end

  create_table "activity_fixture", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "division_code", limit: 10
    t.string "activity_participant_a", limit: 10
    t.string "activity_participant_b", limit: 10
    t.integer "activity_category_div_id"
    t.string "comment", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
  end

  create_table "activity_participant", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "assigned_code", limit: 10
    t.string "division_code", limit: 10
    t.string "participant_name", limit: 255
    t.string "participant_alias", limit: 255
    t.text "image_data"
    t.string "image_path", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
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

  create_table "assigned_fees", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.string "trans_type", limit: 5
    t.decimal "fee", precision: 11, scale: 3, default: "0.0"
    t.string "flat_percent", limit: 5
    t.decimal "cap", precision: 11, scale: 3, default: "0.0"
    t.decimal "limit_capped", precision: 11, scale: 3, default: "0.0"
    t.string "charged_to", limit: 5
    t.string "comment", limit: 255
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.boolean "approved"
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

  create_table "auth_req", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "mobile_number", limit: 20
    t.string "imei", limit: 50
    t.text "secret_code"
    t.string "device_type", limit: 10
    t.boolean "expired", default: false
    t.string "status", limit: 10
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "ref_code", limit: 50
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

  create_table "cust_code_vault", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "payment_info_id"
    t.string "image_path", limit: 255
    t.text "image_data"
    t.string "qr_txt", limit: 255
    t.string "trans_ref_code", limit: 20
    t.boolean "verified", default: false
    t.integer "verified_by"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at"
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

  create_table "duplicate_callback", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "trans_status", limit: 100
    t.string "nw_trans_id", limit: 50
    t.string "trans_ref", limit: 20
    t.string "trans_msg", limit: 255
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.boolean "allow_qr"
    t.string "msg_sender_id", limit: 10
    t.string "sms_sender_id", limit: 10
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

  create_table "entity_service_account", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.decimal "gross_bal", precision: 11, scale: 3
    t.decimal "net_bal", precision: 11, scale: 3
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "entity_service_account_trxn", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.decimal "gross_bal_bef", precision: 11, scale: 3
    t.decimal "gross_bal_aft", precision: 11, scale: 3
    t.decimal "net_bal_bef", precision: 11, scale: 3
    t.decimal "net_bal_aft", precision: 11, scale: 3
    t.string "processing_id", limit: 20
    t.decimal "charge", precision: 11, scale: 3
    t.string "trans_type", limit: 5
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "entity_wallet_configs", force: :cascade do |t|
    t.string "entity_code"
    t.integer "service_id"
    t.string "secret_key"
    t.string "client_key"
    t.text "comment"
    t.boolean "active_status", default: true
    t.boolean "del_status", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activity_type_code"
  end

  create_table "err_log", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "entity_div_code", limit: 10
    t.string "processing_id", limit: 20
    t.string "trans_type", limit: 5
    t.string "nw", limit: 5
    t.text "err_msg"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "payment_callback", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "trans_status", limit: 100
    t.string "nw_trans_id", limit: 50
    t.string "trans_ref", limit: 20
    t.string "trans_msg", limit: 255
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "payment_info", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "session_id", limit: 50
    t.string "entity_div_code", limit: 10
    t.integer "activity_lov_id"
    t.integer "activity_div_id"
    t.boolean "processed"
    t.string "src", limit: 5
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
    t.string "payment_mode", limit: 5
    t.decimal "amount", precision: 11, scale: 3
    t.string "customer_number", limit: 20
    t.string "trans_type", limit: 5
    t.decimal "charge", precision: 11, scale: 3
    t.integer "activity_sub_div_id"
    t.string "activity_main_code", limit: 50
    t.string "paid_by", limit: 255
    t.string "recipient_number", limit: 50
    t.string "recipient_type", limit: 50
    t.string "recipient_email", limit: 255
    t.string "narration", limit: 255
  end

  create_table "payment_request", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "payment_info_id"
    t.string "processing_id", limit: 50
    t.string "customer_number", limit: 20
    t.string "nw", limit: 5
    t.string "trans_type", limit: 5
    t.decimal "amount", precision: 11, scale: 2
    t.integer "service_id"
    t.string "payment_mode", limit: 5
    t.string "reference", limit: 50
    t.boolean "processed"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
  end

  create_table "permission_roles", force: :cascade do |t|
    t.integer "role_id"
    t.integer "permission_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "subject_class"
    t.string "action"
    t.string "name"
    t.string "description"
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

  create_table "roles", force: :cascade do |t|
    t.string "role_name"
    t.boolean "active_status"
    t.boolean "del_status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staged_request", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "processing_id", limit: 20
    t.decimal "amount", precision: 10, scale: 2
    t.string "entity_div_code", limit: 10
    t.string "narration", limit: 50
    t.string "trans_type", limit: 5
    t.integer "payment_info_id"
    t.integer "payment_req_id"
    t.boolean "status"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at"
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

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "user_name"
    t.string "last_name"
    t.string "first_name"
    t.string "contact_number"
    t.integer "free_id"
    t.string "entity_code"
    t.string "division_code"
    t.string "access_type"
    t.integer "role_id"
    t.integer "creator_id"
    t.boolean "active_status"
    t.boolean "del_status"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "ussd_activity_div_cat_temps", id: :serial, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "activity_div_cat_index"
    t.string "activity_div_cat_id"
    t.string "activity_div_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_activity_div_sub_cat_temps", id: :serial, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "activity_div_subcat_index"
    t.string "activity_cat_div_id"
    t.string "category_div_desc"
    t.string "activity_div_category"
    t.string "activity_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
  end

  create_table "ussd_activity_fixtures_temps", id: :serial, force: :cascade do |t|
    t.string "mobile_number"
    t.string "activity_type"
    t.string "activity_code"
    t.string "entity_div_code"
    t.string "activity_fixture_id"
    t.string "participant_a_alias"
    t.string "participant_a"
    t.string "image_a"
    t.string "participant_b_alias"
    t.string "participant_b"
    t.string "activity_category_div"
    t.string "image_b"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.string "fixtures_index"
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
    t.string "activity_category_div"
    t.string "participant_a_alias"
    t.string "participant_a"
    t.string "participant_b_alias"
    t.string "participant_b"
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
    t.decimal "charge", default: "0.0"
    t.string "activity_main_code"
    t.string "total_amount"
    t.string "payment_reference"
    t.integer "activity_sub_plan_id"
    t.string "activity_date"
    t.string "activity_time"
    t.string "classification"
    t.string "activity_plan"
    t.integer "qty"
    t.boolean "allow_qr"
    t.string "email"
    t.string "qr_send_option"
    t.boolean "submit_status", default: false
    t.string "activity_div_cat_id"
    t.string "activity_div_cat_desc"
    t.string "activity_cat_div_id"
    t.string "category_div_desc"
    t.string "activity_category_div"
    t.string "activity_fixture_id"
    t.string "participant_a_alias"
    t.string "participant_a"
    t.string "participant_b_alias"
    t.string "participant_b"
    t.string "activity_plan_id"
    t.string "recipient_number"
    t.string "recipient_type"
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
