class ReviewsController < ApplicationController

  def create
    binding.pry
    @review = Review.new reviews_params
    ActiveRecord::Base.transaction do
      @review.save
      params[:review][:images][:picture].each do |image|
        @image = Image.create(review_id: @review.id, picture: image)
        @image.save
      end
      Evaluation.create(user_id: @review.id, restaurant_id: params[:review][:restaurant_id], star: params[:rate])
    end
  end

  def reviews_params
    params.require(:review).permit(:content, :restaurant_id).merge({user_id: current_user.id})
  end
end