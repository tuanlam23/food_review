class Image < ApplicationRecord
  belongs_to :review
  mount_uploader :picture, PictureUploader
end