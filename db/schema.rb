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

ActiveRecord::Schema[7.2].define(version: 2024_09_29_191408) do
  create_table "quotes", force: :cascade do |t|
    t.string "quotation", null: false
    t.string "source", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "display_quotes", default: true
    t.boolean "burnination", default: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "task_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_task_categories_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "summary", null: false
    t.integer "priority", default: 3, null: false
    t.string "status", default: "INCOMPLETE", null: false
    t.date "due_at"
    t.datetime "completed_at"
    t.integer "task_category_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_category_id"], name: "index_tasks_on_task_category_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.boolean "email_confirmed", default: false
    t.string "time_zone"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "quotes", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "task_categories", "users"
  add_foreign_key "tasks", "task_categories"
  add_foreign_key "tasks", "users"
end
