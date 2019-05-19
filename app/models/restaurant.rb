class Restaurant < ApplicationRecord
  belongs_to :category
  belongs_to :area
  has_many :foods
  mount_uploader :picture, PictureUploader

  def self.factory

  end
end