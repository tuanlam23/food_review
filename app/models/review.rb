class Review < ApplicationRecord
  has_many :images, dependent: :destroy
  has_one :evaluation, dependent: :destroy
  belongs_to :user
  belongs_to :retaurant
  has_many :comments
end