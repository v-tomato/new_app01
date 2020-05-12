require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { User.new(
    name: "Example User",
    email: "user@example.com",
    password: "foobar",
    password_confirmation: "foobar"
  ) }
  

  describe "User" do
    it "should be valid" do
      expect(user).to be_valid
    end
  end
  
#   nameについて
  describe "name" do
    it "gives presence" do
      user.name = "  "
      expect(user).to be_invalid
    end
    
    context "50 characters" do
      it "is not too long" do
        user.name = "a" * 50
        expect(user).to be_valid
      end
    end
    
    context "51 characters" do
      it "is too long" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end
  end
    
# 　emailについて
  describe "email" do 
    it "give presence" do
      user.email = " "
      expect(user).to be_invalid
    end
    
    context "254 characters" do
     it "is not too long" do
        user.email = "a" * 241 + "@example.com"
       expect(user).to be_valid
    end
    
    context "255 characters" do
      it "is too long" do
        user.email = "a" * 244 + "@example.com"
        expect(user).to be_invalid
      end
    end
    
    it "should accept valid addresses" do
      user.email = "user@example.com"
      expect(user).to be_valid

      user.email = "USER@foo.COM"
      expect(user).to be_valid

      user.email = "A_US-ER@foo.bar.org"
      expect(user).to be_valid

      user.email = "first.last@foo.jp"
      expect(user).to be_valid

      user.email = "alice+bob@baz.cn"
      expect(user).to be_valid
    end

    it "should reject invalid addresses" do
      user.email = "user@example,com"
      expect(user).to be_invalid

      user.email = "user_at_foo.org"
      expect(user).to be_invalid

      user.email = "user.name@example."
      expect(user).to be_invalid

      user.email = "foo@bar_baz.com"
      expect(user).to be_invalid

      user.email = "foo@bar+baz.com"
      expect(user).to be_invalid
    end
  end
    
  
    # 一意性の確認テスト　大文字小文字の区別をなくす　6.2.4-5
    it "should be unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end
    
    
    it "should be saved as lower-case" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq 'foo@example.com'
    end
   
  # パスワードのテスト
  describe "password and password_confirmation" do
    it "should be present (nonblank)" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end
    
     context "5 characters" do
      it "is too short" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end

    context "6 characters" do
      it "is not too short" do
        user.password = user.password_confirmation = "a" * 6
        expect(user).to be_valid
      end
    end
   end
    
  end 
  
  #Userモデルのauthenticated?メソッドをテスト
  describe "User model methods" do
    describe "authenticated?" do
      it "return false for a user with nil digest" do
        expect(user.authenticated?(:remember, '')).to be_falsey
      end
    end
  end
  
  # ユーザが削除されたら投稿も削除されるか,14
  it "destroys assosiated microposts" do
    user.save
    user.microposts.create!(memo: "Lorem Ipsum")
    expect{ user.destroy }.to change{ Micropost.count }.by(-1)
  end
end