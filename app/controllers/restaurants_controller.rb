class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.order(created_at: :desc)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

end