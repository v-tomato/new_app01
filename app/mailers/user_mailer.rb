class UserMailer < ApplicationMailer
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【重要】New App01よりアカウント有効化のためのメールを届けました"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【確認】New App01よりパスワードの再設定のためのメールを届けました"
  end
end
