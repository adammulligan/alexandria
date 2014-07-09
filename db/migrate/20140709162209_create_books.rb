class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :filename
      t.text :name
      t.string :thumbnail

      t.timestamps
    end
  end
end
