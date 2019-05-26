class RestaurantsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:follow]
  before_action :check_user, only: [:follow]
  before_action :set_city_filter, only: [:show, :index]
  def index
    @restaurants = Restaurant.where(area_id: @districts.pluck(:id)).order(created_at: :desc).paginate(page: 1, per_page: 2)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @reviews = @restaurant.reviews
    @review = Review.new
  end

  def follow
    follow = Follow.where(restaurant_id: params[:restaurant_id], user_id: current_user.id)
    if follow.present?
      follow.delete_all
      render json: {status: true, data: 'delete'}
    else
      Follow.create(restaurant_id: params[:restaurant_id], user_id: current_user.id)
      render json: {status: true, data: 'success'}
    end
  end

  def load_new
    restaurants = Restaurant.order(created_at: :desc).paginate(page: params[:page], per_page: 2)
    strhtml = render_to_string partial: '/restaurants/restaurant', locals: { restaurants: restaurants, user: current_user }, formats: :html
    content = strhtml.html_safe
    render json: {content: content, last_page: restaurants.total_pages,
                  next_page: restaurants.current_page + 1}
  end

  def load_follow
    restaurant_ids = current_user.follows.pluck(:restaurant_id)
    restaurants = Restaurant.where(id: restaurant_ids).paginate(page: params[:page], per_page: 2)
    if restaurants.present?
      strhtml = render_to_string partial: '/restaurants/restaurant', locals: { restaurants: restaurants, user: current_user }, formats: :html
      content = strhtml.html_safe
      render json: {content: content, last_page: restaurants.total_pages,
                    next_page: restaurants.current_page + 1}
    else
      render json: {content: 'Chưa có dữ liệu', status: 274}
    end
  end

  def set_city_filter
    @area_parent = Area.where(parent_id: nil)
    if params[:city].present?
      session[:city] = params[:city]
    elsif session[:city].blank?
      session[:city] = @area_parent.first.id
    end
    @districts = Area.where(parent_id: session[:city])
    @categories = Category.all
  end

  # private
  def check_user
    render json: { status: false, message: 'Error' } if current_user.blank?
  end

end