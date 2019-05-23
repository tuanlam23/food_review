class RestaurantsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:follow]
  before_action :check_user, only: [:follow]
  def index
    @restaurants = Restaurant.order(created_at: :desc)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
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
    page = params[:page].to_i + 1
    restaurants = Restaurant.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
    strhtml = render_to_string partial: '/questions/new_attachment', locals: { original_file: of, dropzone_id: params[:dropzone_id] }, formats: :html
  end

  # private
  def check_user
    render json: { status: false, message: 'Error' } if current_user.blank?
  end

end