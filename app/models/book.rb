class Book < ActiveRecord::Base
  mount_uploader :file, BookUploader
end
