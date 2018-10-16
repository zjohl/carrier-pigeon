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

ActiveRecord::Schema.define(version: 2018_10_16_150158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.integer "drone_id"
    t.float "origin_longitude"
    t.float "origin_latitude"
    t.float "destination_longitude"
    t.float "destination_latitude"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
  end

  create_table "drones", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "destination_latitude"
    t.float "destination_longitude"
    t.string "status"
    t.integer "battery_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_contacts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "contact_id"
    t.index ["user_id", "contact_id"], name: "index_user_contacts_on_user_id_and_contact_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password"
  end

  add_foreign_key "user_contacts", "users"
  add_foreign_key "user_contacts", "users", column: "contact_id"
end
