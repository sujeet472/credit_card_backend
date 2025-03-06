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

ActiveRecord::Schema[7.2].define(version: 2025_03_06_090516) do
  create_table "account_transactions", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "user_card_id", limit: 20, null: false
    t.datetime "transaction_date", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "merchant_id", limit: 20, null: false
    t.string "location", limit: 100
    t.string "transaction_type", limit: 50, default: "purchase", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_account_transactions_on_discarded_at"
  end

  create_table "branches", id: :string, force: :cascade do |t|
    t.string "branch_name", limit: 50, null: false
    t.text "branch_address", null: false
    t.string "branch_manager", limit: 50, null: false
    t.string "branch_phone", limit: 15, null: false
    t.string "branch_email", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["branch_email"], name: "index_branches_on_branch_email", unique: true
    t.index ["branch_phone"], name: "index_branches_on_branch_phone", unique: true
    t.index ["discarded_at"], name: "index_branches_on_discarded_at"
  end

  create_table "credit_cards", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "type_of_card", null: false
    t.decimal "credit_limit", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_credit_cards_on_discarded_at"
  end

  create_table "profiles", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.date "date_of_birth", null: false
    t.string "email", limit: 100, null: false
    t.integer "phone_number", limit: 15, null: false
    t.text "address", null: false
    t.string "branch_id", limit: 20
    t.string "profile_image", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_type", default: "saving", null: false
    t.datetime "discarded_at"
    t.integer "users_id"
    t.index ["discarded_at"], name: "index_profiles_on_discarded_at"
    t.index ["email"], name: "index_profiles_on_email", unique: true
    t.index ["phone_number"], name: "index_profiles_on_phone_number", unique: true
    t.index ["users_id"], name: "index_profiles_on_users_id"
  end

  create_table "rewards", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "account_transaction_id", limit: 20, null: false
    t.string "user_card_id", limit: 20, null: false
    t.integer "points_earned", null: false
    t.integer "points_redeemed", null: false
    t.datetime "last_updated", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["account_transaction_id"], name: "index_rewards_on_account_transaction_id"
    t.index ["discarded_at"], name: "index_rewards_on_discarded_at"
    t.index ["user_card_id"], name: "index_rewards_on_user_card_id"
  end

  create_table "user_cards", id: { type: :string, limit: 20 }, force: :cascade do |t|
    t.string "credit_card_id", limit: 20, null: false
    t.string "profile_id", limit: 20, null: false
    t.date "issue_date", null: false
    t.date "expiry_date", null: false
    t.boolean "is_active", default: true
    t.decimal "available_limit", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashed_cvv"
    t.datetime "discarded_at"
    t.index ["credit_card_id"], name: "index_user_cards_on_credit_card_id"
    t.index ["discarded_at"], name: "index_user_cards_on_discarded_at"
    t.index ["profile_id"], name: "index_user_cards_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_transactions", "user_cards"
  add_foreign_key "account_transactions", "user_cards", column: "merchant_id"
  add_foreign_key "profiles", "branches"
  add_foreign_key "profiles", "users", column: "users_id"
  add_foreign_key "rewards", "account_transactions"
  add_foreign_key "rewards", "user_cards"
  add_foreign_key "user_cards", "credit_cards"
  add_foreign_key "user_cards", "profiles"
end
