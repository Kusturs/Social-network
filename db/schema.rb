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

ActiveRecord::Schema[7.1].define(version: 2024_10_08_213534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.bigint "parent_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id", "created_at"], name: "index_comments_on_post_id_and_created_at"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_subscriptions_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_subscriptions_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_subscriptions_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "first_name", null: false
    t.string "second_name"
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "followers_count", default: 0
    t.integer "followed_users_count", default: 0
    t.index ["last_name", "first_name"], name: "index_users_on_last_name_and_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "subscriptions", "users", column: "followed_id"
  add_foreign_key "subscriptions", "users", column: "follower_id"
end
