class Admin::UsersController <  Admin::AdminController
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end
end
