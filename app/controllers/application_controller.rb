class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
     # ログイン済みユーザーかどうか確認
     # logged_in_userメソッドはMicroposts・Userコントローラの両方で使用
    def logged_in_user
      #真偽値を返す
      unless logged_in?   
      store_location 
      flash[:warning] = "ログインして下さい"
      redirect_to login_url
    end
  end
  
end
