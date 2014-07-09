class AddFileToBook < ActiveRecord::Migration
  def change
    add_column :books, :file, :string
  end
end
