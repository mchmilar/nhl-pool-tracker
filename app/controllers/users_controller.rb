class UsersController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to groups_path
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  def logged_in_user
    redirect_to login_path, notice: "Please login." unless logged_in?
  end
end
