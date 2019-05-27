require "./lib/recommendation.rb"
class User < ApplicationRecord
  has_many :follows
  has_many :evaluations
  has_many :reviews
  has_many :restaurants, through: :follows
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  include Recommendation

  def self.new_with_session params, session
    super.tap do |user|
      if data = session["devise.facebook_data"] &&
          session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end

  def recommend_restaurants
    other_users = Restaurant.where.not(id: self.id)
    recommended = Hash.new(0)
    other_users.each do |user|
      common_restaurants = user.restaurants & self.restaurants
      weight = common_restaurants.size.to_f / user.restaurants.size
      (user.restaurants - common_restaurants).each do |restaurant|
        recommended[restaurant] += weight
      end
    end
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    if sorted_recommended.blank?
      res = self.restaurants.map(&:id)
      return  Restaurant.where.not(id: res).order(number_star: :desc)
    else
      return sorted_recommended
    end
  end
end
