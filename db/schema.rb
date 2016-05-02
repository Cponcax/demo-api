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

ActiveRecord::Schema.define(version: 20160602200405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "streaming_url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_color"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "access_token"
    t.boolean  "logo_processing"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 100, null: false
    t.integer  "code"
    t.string   "alpha2",     limit: 2
    t.string   "alpha3",     limit: 3
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

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

  create_table "payment_tokens", force: :cascade do |t|
    t.string   "token_type"
    t.string   "expires_in"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.string   "access_token"
  end

  add_index "payment_tokens", ["user_id"], name: "index_payment_tokens_on_user_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.integer  "schedule_id"
    t.string   "name",        limit: 80
    t.string   "url_image",              default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "start_time"
  end

  add_index "reminders", ["channel_id"], name: "index_reminders_on_channel_id", using: :btree
  add_index "reminders", ["schedule_id"], name: "index_reminders_on_schedule_id", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.integer  "channel_id"
    t.date     "date"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "turn"
  end

  add_index "schedules", ["channel_id"], name: "index_schedules_on_channel_id", using: :btree

  create_table "shows", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "rating"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.boolean  "logo_processing"
    t.boolean  "cover_processing"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.boolean  "cancelled",      default: false
    t.string   "transaction_id"
    t.string   "identifier"
    t.boolean  "payment"
    t.boolean  "status"
  end

  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.integer  "country_id"
    t.datetime "deleted_at"
    t.string   "status"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                 default: 0
  end

  add_index "users", ["country_id"], name: "index_users_on_country_id", using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "itunes_receipts", "users"
  add_foreign_key "payment_tokens", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users", "countries"
end
