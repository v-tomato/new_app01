class UsersController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "New App01 の世界へようこそ"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end


private
  # Strong Parameters 7.3.2
  def user_params
    # params.permit(:name, :email, :password, :password_confirmation)
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  

end