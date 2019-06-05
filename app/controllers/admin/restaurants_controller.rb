# require "will_paginate-bootstrap"
class Admin::RestaurantsController < Admin::AdminController

  def index
    @restaurants = Restaurant.paginate(page: params[:page], per_page: 10)
  end

  def new
    @restaurant = Restaurant.new
    @categories = Category.pluck(:name, :id)
    @city = Area.where(parent_id: nil).pluck(:name, :id)
    @area = Area.where(parent_id: @city.first).pluck(:name, :id)
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if params[:food].present?
      params[:food].each do |food|
        @restaurant.foods << Food.new(food_params(food))
      end
    end
    @restaurant.save
    if @restaurant.valid?
      flash[:success] = "Thêm mới thành công"
     redirect_to admin_restaurants_path
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    @categories = Category.pluck(:name, :id)
    @city = Area.where(parent_id: nil).pluck(:name, :id)
    @current_city = @restaurant.area.parent_id
    @area = Area.where(parent_id: @current_city).pluck(:name, :id)
    @current_area = @restaurant.area.id
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    param = params[:restaurant] || {}
    ActiveRecord::Base.transaction do
      @restaurant.name = param[:name]
      @restaurant.description = param[:description]
      @restaurant.area_id = param[:area_id]
      @restaurant.address = param[:address]
      @restaurant.category_id = param[:category_id]
      @restaurant.open_time = param[:open_time]
      @restaurant.phone = param[:phone]
      if params[:food].blank?
        @restaurant.foods.delete_all
      else
        food_ids = params[:food].keys.map(&:to_i)
        @restaurant.foods.where.not(id: food_ids).delete_all
        params[:food].each do |key, value|
          puts "#{key} is #{value}"
          id = key.to_i
          if value["picture"].blank?
            Food.find(id).update(name: value["name"], price: value["price"])
          else
            Food.find(id).update(name: value["name"], price: value["price"], picture: value["picture"])
          end
        end
      end
      if params[:foods].present?
        params[:foods].each do |food|
          Food.create(name: food[:name], price: food[:price], picture: food[:picture], restaurant_id: @restaurant.id)
        end
      end
      if param[:picture].present?
        @restaurant.picture = param[:picture]
      end
      @restaurant.save
      flash[:success] = "Cập nhật thành công"
    end
    redirect_to admin_restaurants_path
  end

  def area
    area = Area.where(parent_id: params[:id]).pluck(:name, :id)
    render json: {status: true, data: area}
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