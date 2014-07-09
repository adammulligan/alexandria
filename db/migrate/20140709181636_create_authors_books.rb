class CreateAuthorsBooks < ActiveRecord::Migration
  def change
    create_table :authors_books do |t|
      t.references :author
      t.references :book
    end

    add_index :authors_books, [:author_id, :book_id]
    add_index :authors_books, :book_id
  end
end
