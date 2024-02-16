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

ActiveRecord::Schema[7.1].define(version: 2024_02_11_212612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.string "summary_1"
    t.string "summary_2"
    t.string "summary_3"
    t.string "summary_4"
    t.bigint "paper_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_analyses_on_paper_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "paper_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_chats_on_paper_id"
  end

  create_table "citations", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.integer "published_year"
    t.string "doi"
    t.integer "citations_count"
    t.bigint "paper_id", null: false
    t.bigint "graph_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["graph_id"], name: "index_citations_on_graph_id"
    t.index ["paper_id"], name: "index_citations_on_paper_id"
  end

  create_table "graphs", force: :cascade do |t|
    t.bigint "paper_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_graphs_on_paper_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "body"
    t.string "sender"
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "papers", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.integer "published_year"
    t.string "doi"
    t.integer "size"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_papers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "analyses", "papers"
  add_foreign_key "chats", "papers"
  add_foreign_key "citations", "graphs"
  add_foreign_key "citations", "papers"
  add_foreign_key "graphs", "papers"
  add_foreign_key "messages", "chats"
  add_foreign_key "papers", "users"
end
