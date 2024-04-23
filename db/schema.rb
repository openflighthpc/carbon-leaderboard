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

ActiveRecord::Schema[7.1].define(version: 2024_04_23_175345) do
  create_table "devices", id: false, force: :cascade do |t|
    t.string "uuid"
    t.integer "user_id"
    t.integer "cpus"
    t.integer "cores_per_cpu"
    t.float "ram_units"
    t.float "ram_capacity_per_unit"
    t.float "min"
    t.float "half"
    t.float "max"
    t.string "platform"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tags", default: "[]"
    t.string "cpu_name"
    t.text "disks"
    t.text "gpus"
    t.string "cloud_provider"
    t.string "instance_type"
    t.string "display_name"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "device_id", null: false
    t.float "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_reports_on_device_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
