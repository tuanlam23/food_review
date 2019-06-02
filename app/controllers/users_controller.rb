class UsersController < ApplicationController
  def show
    @reviews = Review.where(user_id: params[:id])
  end
end
