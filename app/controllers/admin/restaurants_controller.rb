# require "will_paginate-bootstrap"
class Admin::RestaurantsController < Admin::AdminController

  def index
    @restaurants = Restaurant.paginate(page: params[:page], per_page: 10)
  end

  def new
    @retaurant = Restaurant.new
    @categories = Category.pluck(:name, :id)
    @city = Area.where(parent_id: nil).pluck(:name, :id)
    @area = Area.where(parent_id: @city.first).pluck(:name, :id)
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    params[:food].each do |food|
      @restaurant.foods << Food.new(food_params(food))
    end
    @restaurant.save
    if @restaurant.valid?
     redirect_to admin_restaurants_path
    else
      render 'new'
    end
  end

  def edit

  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :open_time,
                  :area_id, :phone, :address, :category_id, :picture)
  end

  def food_params(food_params)
    food_params.permit(:name, :price, :picture)
  end

end