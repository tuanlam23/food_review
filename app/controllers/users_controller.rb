class UsersController < ApplicationController
  before_action :set_city_filter, only: [:show, :follow, :profile]

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

  def update
    param = params[:user] || {}
    current_user.update(name: param[:name], birthday: param[:birthday], descriptions: param[:descriptions])
    if param[:image].present?
      current_user.update(image: param[:image])
    end
    redirect_to profile_users_path
  end

end
