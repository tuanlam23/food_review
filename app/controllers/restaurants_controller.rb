class RestaurantsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:follow]
  before_action :check_user, only: [:follow]
  before_action :set_city_filter, only: [:show, :index, :search]
  def index
    if current_user.present?
      @recommend_res = current_user.recommend_restaurants.map(&:first)[0..7]
    else
      @recommend_res = Restaurant.order(number_star: :desc).limit(8)
    end
    @restaurants = Restaurant.where(area_id: @districts.pluck(:id)).order(created_at: :desc).paginate(page: 1, per_page: 8)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @reviews = @restaurant.reviews.paginate(page: params[:page], per_page: 3)
    @review = Review.new
    @review_user = @restaurant.reviews.find_by(user_id: current_user.id) if current_user
    @address = @restaurant.address + ", " + @restaurant.area.district
  end

  def search
    if params[:district].blank?
      params[:district] = Area.where(parent_id: session[:city]).pluck(:id)
    end
    @restaurants = Restaurant.search_by(params)
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
    restaurants = Restaurant.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
    strhtml = render_to_string partial: '/restaurants/restaurant', locals: { restaurants: restaurants, user: current_user }, formats: :html
    content = strhtml.html_safe
    render json: {content: content, last_page: restaurants.total_pages,
                  next_page: restaurants.current_page + 1}
  end

  def load_follow
    restaurant_ids = current_user.follows.pluck(:restaurant_id)
    restaurants = Restaurant.where(id: restaurant_ids).paginate(page: params[:page], per_page: 8)
    if restaurants.present?
      strhtml = render_to_string partial: '/restaurants/restaurant', locals: { restaurants: restaurants, user: current_user }, formats: :html
      content = strhtml.html_safe
      render json: {content: content, last_page: restaurants.total_pages,
                    next_page: restaurants.current_page + 1}
    else
      render json: {content: 'Chưa có dữ liệu', status: 274}
    end
  end

  # private
  def check_user
    render json: { status: false, message: 'Error' } if current_user.blank?
  end

end