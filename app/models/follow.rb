class Follow < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  def self.check_follow(restaurant_id, user_id)
    where(restaurant_id: restaurant_id, user_id: user_id).present?
  end
end