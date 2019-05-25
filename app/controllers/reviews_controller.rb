class ReviewsController < ApplicationController

  def create
    @review = Review.new reviews_params
    restaurant = Restaurant.find(params[:review][:restaurant_id])
    ActiveRecord::Base.transaction do
      @review.save
      params[:review][:images][:picture].each do |image|
        @image = Image.create(review_id: @review.id, picture: image)
        @image.save
      end
      Evaluation.create(review_id: @review.id, restaurant_id: params[:review][:restaurant_id], star: params[:rate])
      restaurant.update(number_star: restaurant.evaluations.average(:star).to_i)
    end

    redirect_to params[:url]
  end

  def reviews_params
    params.require(:review).permit(:content, :restaurant_id).merge({user_id: current_user.id})
  end
end