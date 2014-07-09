class Book < ActiveRecord::Base
  mount_uploader :file, BookUploader

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :authors
end
