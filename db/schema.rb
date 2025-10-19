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

ActiveRecord::Schema[8.0].define(version: 2025_10_19_083536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "calenders", force: :cascade do |t|
    t.bigint "villa_id", null: false
    t.date "stay_date", null: false
    t.boolean "available", default: true, null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["available", "stay_date"], name: "index_calenders_on_available_and_stay_date"
    t.index ["villa_id"], name: "index_calenders_on_villa_id"
  end

  create_table "villas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
