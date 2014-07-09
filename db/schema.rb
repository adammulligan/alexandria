# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140709182801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "authors_books", force: true do |t|
    t.integer "author_id"
    t.integer "book_id"
  end

  add_index "authors_books", ["author_id", "book_id"], name: "index_authors_books_on_author_id_and_book_id", using: :btree
  add_index "authors_books", ["book_id"], name: "index_authors_books_on_book_id", using: :btree

  create_table "books", force: true do |t|
    t.text     "filename"
    t.text     "name"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  create_table "books_categories", force: true do |t|
    t.integer "book_id"
    t.integer "category_id"
  end

  add_index "books_categories", ["book_id", "category_id"], name: "index_books_categories_on_book_id_and_category_id", using: :btree
  add_index "books_categories", ["category_id"], name: "index_books_categories_on_category_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
