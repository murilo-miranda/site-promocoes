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

ActiveRecord::Schema.define(version: 2021_07_21_210337) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code"
    t.integer "promotion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["promotion_id"], name: "index_coupons_on_promotion_id"
  end

  create_table "promotion_approvals", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.integer "promotion_id", null: false
    t.datetime "approved_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_promotion_approvals_on_admin_id"
    t.index ["promotion_id"], name: "index_promotion_approvals_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "code"
    t.decimal "discount_rate"
    t.integer "coupon_quantity"
    t.date "expiration_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id", null: false
    t.index ["admin_id"], name: "index_promotions_on_admin_id"
  end

  add_foreign_key "coupons", "promotions"
  add_foreign_key "promotion_approvals", "admins"
  add_foreign_key "promotion_approvals", "promotions"
  add_foreign_key "promotions", "admins"
end
