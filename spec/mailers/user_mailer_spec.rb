require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  let(:user) { create(:user) }

  describe "account_activation" do
    it "renders mails" do
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq("【重要】New App01よりアカウント有効化のためのメールを届けました")
      expect(mail.to).to eq(["michael@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include("Michael Example")
    end
  end

  describe "password_reset" do
    it "renders mails" do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq "【確認】New App01よりパスワードの再設定のためのメールを届けました"
      expect(mail.to).to eq ["michael@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include "Michael Example"
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include user.reset_token
      expect(mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join).to include CGI.escape(user.email)
    end
  end
end