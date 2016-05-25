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

ActiveRecord::Schema.define(version: 20160519205840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_informations", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "subscription_id"
    t.string   "receipt_number"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "billing_informations", ["customer_id"], name: "index_billing_informations_on_customer_id", using: :btree
  add_index "billing_informations", ["receipt_number"], name: "index_billing_informations_on_receipt_number", unique: true, using: :btree
  add_index "billing_informations", ["subscription_id"], name: "index_billing_informations_on_subscription_id", using: :btree

  create_table "billing_plans", force: :cascade do |t|
    t.integer  "amount"
    t.string   "currency"
    t.string   "interval"
    t.integer  "interval_count",    default: 1
    t.string   "name"
    t.integer  "trial_period_days"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "streaming_url"
    t.string   "logo_color"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 100, null: false
    t.integer  "code"
    t.string   "alpha2",     limit: 2
    t.string   "alpha3",     limit: 3
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "show_id"
    t.integer  "schedule_id"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "streaming_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "events", ["schedule_id"], name: "index_events_on_schedule_id", using: :btree
  add_index "events", ["show_id"], name: "index_events_on_show_id", using: :btree

  create_table "itunes_receipts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "receipt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "itunes_receipts", ["user_id"], name: "index_itunes_receipts_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.integer  "schedule_id"
    t.string   "name",        limit: 80
    t.string   "url_image",              default: ""
    t.datetime "start_time"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "reminders", ["channel_id"], name: "index_reminders_on_channel_id", using: :btree
  add_index "reminders", ["schedule_id"], name: "index_reminders_on_schedule_id", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "channel_id"
    t.date     "date"
    t.string   "name"
    t.string   "turn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "schedules", ["channel_id"], name: "index_schedules_on_channel_id", using: :btree

  create_table "shows", force: :cascade do |t|
    t.string   "name"
    t.string   "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "billing_plan_id"
    t.integer  "customer_id"
    t.datetime "canceled_at"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.string   "status"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "subscriptions", ["billing_plan_id"], name: "index_subscriptions_on_billing_plan_id", using: :btree
  add_index "subscriptions", ["customer_id"], name: "index_subscriptions_on_customer_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "token_type"
    t.integer  "expires_in"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tokens", ["customer_id"], name: "index_tokens_on_customer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "code",                   limit: 8,               null: false
    t.string   "username",               limit: 80
    t.string   "first_name",             limit: 80
    t.string   "last_name",              limit: 80
    t.string   "gender"
    t.text     "bio"
    t.date     "birth_date"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "deleted_at"
    t.string   "status"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  add_foreign_key "itunes_receipts", "users"
end
