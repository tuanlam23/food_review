class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.new reviews_params
    restaurant = Restaurant.find(params[:review][:restaurant_id])
    ActiveRecord::Base.transaction do
      @review.save
      if params[:review][:images].present?
        params[:review][:images][:picture].each do |image|
          @image = Image.create(review_id: @review.id, picture: image)
          @image.save
        end
      end
      Evaluation.create(review_id: @review.id, restaurant_id: params[:review][:restaurant_id], star: params[:rate])
      restaurant.update(number_star: restaurant.evaluations.average(:star).to_i)
    end

    redirect_to params[:url]
  end

  def update
    binding.pry
    @review = Review.find(params[:id])
    if params[:images_edit].present?
      img_delete = params[:images_edit].split(" ")
      image = img_delete.map(&:to_i) if img_delete
    end
    count = 0
    add_img = [-1]
    if params[:images_add].present?
      imgs = params[:images_add].split(" ")
      add_img = imgs.map(&:to_i) if imgs
    end
    ActiveRecord::Base.transaction do
      @review.content = params[:review][:content]
      if image
        Image.where(id: image).delete_all
      end
      if params[:review][:images].present?
        params[:review][:images][:picture].each_with_index  do |image, index|
          next if add_img.include?(index)
          image = Image.create(review_id: @review.id, picture: image)
        end
      end
      @review.evaluation.update(star: params[:rate])
      @review.restaurant.update(number_star: @review.restaurant.evaluations.average(:star).to_i)
      @review.save
    end

    redirect_to params[:url]
  end

  def destroy
    Review.find(params[:id]).destroy
    render json: {status: true, status: 200}
  end

  def reviews_params
    params.require(:review).permit(:content, :restaurant_id).merge({user_id: current_user.id})
  end
end