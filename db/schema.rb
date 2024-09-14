# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_14_115916) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "edit_count", default: 0, null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "direct_message_requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_direct_message_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_direct_message_requests_on_sender_id"
  end

  create_table "exps", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "points", null: false
    t.string "source", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "related_entity_type", null: false
    t.bigint "related_entity_id", null: false
    t.index ["related_entity_type", "related_entity_id"], name: "index_exps_on_related_entity"
    t.index ["user_id"], name: "index_exps_on_user_id"
  end

  create_table "levels", charset: "utf8mb3", force: :cascade do |t|
    t.integer "level_number", null: false
    t.integer "exp_required", null: false
    t.integer "hp_increase", null: false
    t.string "reward_type"
    t.string "reward_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level_number"], name: "index_levels_on_level_number", unique: true
  end

  create_table "messages", charset: "utf8mb3", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", charset: "utf8mb3", force: :cascade do |t|
    t.string "message", null: false
    t.bigint "user_id", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type"
    t.bigint "direct_message_request_id"
    t.index ["direct_message_request_id"], name: "index_notifications_on_direct_message_request_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", charset: "utf8mb3", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "room_users", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id", "room_id"], name: "index_room_users_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_room_users_on_user_id"
  end

  create_table "rooms", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "is_group", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sns_credentials", charset: "utf8mb3", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sns_credentials_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "threads_count", default: 0
    t.integer "comments_count", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thought"
    t.string "profile_image"
    t.integer "level_id", default: 1, null: false
    t.integer "experience_points", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "direct_message_requests", "users", column: "receiver_id"
  add_foreign_key "direct_message_requests", "users", column: "sender_id"
  add_foreign_key "exps", "users"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "direct_message_requests"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "room_users", "rooms"
  add_foreign_key "room_users", "users"
  add_foreign_key "sns_credentials", "users"
end
