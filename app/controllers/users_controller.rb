class UsersController < ApplicationController
  before_action :set_city_filter, only: [:show, :follow]

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id]).paginate(page: params[:page], per_page: 6)
  end

  def follow
    @user = User.find(params[:user_id])
    @restaurants = @user.restaurants.paginate(page: params[:page], per_page: 6)
  end

  def profile

  end
end
