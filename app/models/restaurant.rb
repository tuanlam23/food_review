class Restaurant < ApplicationRecord
  belongs_to :category
  belongs_to :area
  has_many :foods
  has_many :follows
  has_many :evaluations
  has_many :reviews
  mount_uploader :picture, PictureUploader

  def self.factory

  end
end