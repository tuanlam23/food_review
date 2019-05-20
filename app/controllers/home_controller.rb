class HomeController < ApplicationController
  # before_action :authenticate_user!
  def index
    @restaurants = Restaurant.order(created_at: :desc)
  end
end
