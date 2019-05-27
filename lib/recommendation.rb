module Recommendation
  def recommend_restaurants
    other_users = self.class.all.where.not(id: self.id)
    recommended = Hash.new(0)
    other_users.each do |user|
      common_restaurants = user.restaurants & self.restaurants
      weight = common_restaurants.size.to_f / user.restaurants.size
      (user.restaurants - common_restaurants).each do |restaurant|
        recommended[restaurant] += weight
      end
    end
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
  end
end