require "will_paginate-bootstrap"
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
    binding.pry
    Restaurant.create(restaurant_params)
    redirect_to admin_restaurants_path
  end

  def edit

  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :picture, :open_time,
                  :area_id, :phone, :address)
  end

end