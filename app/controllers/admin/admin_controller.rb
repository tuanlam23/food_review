class Admin::AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    binding.pry
    true
  end


end
