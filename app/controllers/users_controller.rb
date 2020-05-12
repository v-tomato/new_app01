class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update, :show]
  before_action :correct_user, only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "認証用メールを送信しました。登録時のメールアドレスから認証を済ませてください"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(10)
    # per(10)は1ページの表示数を表す
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'プロフィールの編集に成功しました'
      redirect_to @user
    else
      flash[:danger] = 'プロフィールの編集に失敗しました'
      redirect_to edit_user_path(@user)
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end


  private
    # Strong Parameters 7.3.2
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # 正しいユーザーかどうか確認 10.2.2 #11
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
      # redirect_to(root_url) unless @user == current_user
    end
  end
  
