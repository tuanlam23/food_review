class Restaurant < ApplicationRecord
  has_one :category
  has_one :area
  mount_uploader :picture, PictureUploader

  def self.factory

  end
end