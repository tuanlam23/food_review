class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
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
    @header = true
    users = []
    user_review = Review.all.group(:user_id).count
    user_review.sort_by(&:last).reverse[0...12].each do |user|
      users << user[0]
    end
    @top_users = User.where(id: users)
  end
end
