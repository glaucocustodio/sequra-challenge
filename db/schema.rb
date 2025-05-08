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

ActiveRecord::Schema[8.0].define(version: 2025_05_08_083530) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "merchant_disbursement_frequency", ["daily", "weekly"]

  create_table "merchants", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.string "reference", null: false
    t.string "email", null: false
    t.date "live_on", null: false
    t.enum "disbursement_frequency", null: false, enum_type: "merchant_disbursement_frequency"
    t.float "minimum_monthly_fee", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_merchants_on_reference", unique: true
    t.index ["uuid"], name: "index_merchants_on_uuid", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "merchant_id", null: false
    t.integer "amount_in_cents", null: false
    t.date "placed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commission_fee_in_cents", default: 0, null: false
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
    t.index ["uuid"], name: "index_orders_on_uuid", unique: true
  end

  add_foreign_key "orders", "merchants"
end
