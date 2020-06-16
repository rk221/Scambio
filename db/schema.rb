# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_16_041537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "title", null: false
    t.string "image_icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_games_on_title", unique: true
  end

  create_table "item_genre_games", force: :cascade do |t|
    t.boolean "enable_flag", default: false, null: false
    t.bigint "item_genre_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_item_genre_games_on_game_id"
    t.index ["item_genre_id", "game_id"], name: "index_item_genre_games_on_item_genre_id_and_game_id", unique: true
    t.index ["item_genre_id"], name: "index_item_genre_games_on_item_genre_id"
  end

  create_table "item_genres", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.string "default_unit_name", limit: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_item_genres_on_name", unique: true
  end

  create_table "item_trade_chats", force: :cascade do |t|
    t.bigint "item_trade_detail_id", null: false
    t.boolean "sender_is_seller", null: false
    t.string "message", limit: 200, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_trade_detail_id"], name: "index_item_trade_chats_on_item_trade_detail_id"
  end

  create_table "item_trade_details", force: :cascade do |t|
    t.bigint "item_trade_queue_id", null: false
    t.integer "buy_popuarity"
    t.integer "sale_popuarity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_trade_queue_id"], name: "index_item_trade_details_on_item_trade_queue_id"
  end

  create_table "item_trade_queues", force: :cascade do |t|
    t.boolean "enable_flag", default: true, null: false
    t.boolean "establish_flag"
    t.bigint "item_trade_id", null: false
    t.bigint "user_id"
    t.integer "lock_version", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_trade_id"], name: "index_item_trade_queues_on_item_trade_id"
    t.index ["user_id"], name: "index_item_trade_queues_on_user_id"
  end

  create_table "item_trades", force: :cascade do |t|
    t.integer "buy_item_quantity", null: false
    t.integer "sale_item_quantity", null: false
    t.boolean "enable_flag", null: false
    t.datetime "trade_deadline", null: false
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.bigint "buy_item_id", null: false
    t.bigint "sale_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "enable_item_trade_queue_id"
    t.index ["buy_item_id"], name: "index_item_trades_on_buy_item_id"
    t.index ["enable_item_trade_queue_id"], name: "index_item_trades_on_enable_item_trade_queue_id"
    t.index ["game_id"], name: "index_item_trades_on_game_id"
    t.index ["sale_item_id"], name: "index_item_trades_on_sale_item_id"
    t.index ["user_id"], name: "index_item_trades_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", limit: 30, null: false
    t.string "unit_name", limit: 10
    t.bigint "item_genre_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_items_on_game_id"
    t.index ["item_genre_id"], name: "index_items_on_item_genre_id"
  end

  create_table "nintendo_friend_codes", force: :cascade do |t|
    t.string "friend_code", limit: 12, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_nintendo_friend_codes_on_user_id"
  end

  create_table "play_station_network_ids", force: :cascade do |t|
    t.string "psn_id", limit: 16, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_play_station_network_ids_on_user_id"
  end

  create_table "user_game_ranks", force: :cascade do |t|
    t.integer "rank", default: 0, null: false
    t.integer "popularity", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "buy_trade_count", default: 0, null: false
    t.integer "sale_trade_count", default: 0, null: false
    t.index ["game_id"], name: "index_user_game_ranks_on_game_id"
    t.index ["user_id", "game_id"], name: "index_user_game_ranks_on_user_id_and_game_id", unique: true
    t.index ["user_id"], name: "index_user_game_ranks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "nickname", limit: 30, null: false
    t.date "birthdate", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin_flag", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "item_genre_games", "games"
  add_foreign_key "item_genre_games", "item_genres"
  add_foreign_key "item_trade_chats", "item_trade_details"
  add_foreign_key "item_trade_details", "item_trade_queues"
  add_foreign_key "item_trade_queues", "item_trades"
  add_foreign_key "item_trade_queues", "users"
  add_foreign_key "item_trades", "games"
  add_foreign_key "item_trades", "item_trade_queues", column: "enable_item_trade_queue_id"
  add_foreign_key "item_trades", "items", column: "buy_item_id"
  add_foreign_key "item_trades", "items", column: "sale_item_id"
  add_foreign_key "item_trades", "users"
  add_foreign_key "items", "games"
  add_foreign_key "items", "item_genres"
  add_foreign_key "nintendo_friend_codes", "users"
  add_foreign_key "play_station_network_ids", "users"
  add_foreign_key "user_game_ranks", "games"
  add_foreign_key "user_game_ranks", "users"
end
