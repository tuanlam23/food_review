class Admin::RestaurantsController < Admin::AdminController

  def index

  end

  def new
    @retaurant = Restaurant.new
    @categories = Category.all
    @city = Area.where(parent_id: nil).pluck(:name, :id)
    @area = Area.where(parent_id: @city.first).pluck(:name, :id)
  end

  def create
    Restaurant.create(restaurant_params)
    redirect_to admin_restaurants_path
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :picture, :open_time,
                  :area_id, :phone, :address)
  end

end