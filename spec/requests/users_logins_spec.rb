require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper

  let(:user) { create(:user) }
  let(:no_activation_user) { create(:no_activation_user) }

  def post_invalid_information
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
  end

  def post_valid_information(login_user, remember_me = 0)
    post login_path, params: {
      session: {
        email: login_user.email,
        password: login_user.password,
        remember_me: remember_me
      }
    }
  end

  describe "GET /login" do
    it "fails having a danger flash message" do
      get login_path
      post_invalid_information
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
      expect(request.fullpath).to eq '/login'
    end

    it "fails because they have not activated account" do
      get login_path
      post_valid_information(no_activation_user)
      expect(flash[:danger]).to be_truthy
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end

    it "succeeds having no danger flash message" do
      get login_path
      post_valid_information(user)
      expect(flash[:danger]).to be_falsey
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
    end
  end
    
    it "is valid signup information" do
      get signup_path
      expect { post_valid_information }.to change(User, :count).by(1)
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
      expect(flash[:info]).to be_truthy
    end
    #ここまで12
    
  it "succeeds logout" do
        get login_path
        post_valid_information
        expect(is_logged_in?).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
        delete logout_path
        expect(is_logged_in?).to be_falsey
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

# 　二度ログアウトできたとして、それでもエラーは起こらないか
  it "does not log out twice" do
    get login_path
    post_valid_information(0)
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    expect(request.fullpath).to eq '/users/1'
    delete logout_path
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(request.fullpath).to eq '/'
    delete logout_path
    follow_redirect!
    expect(request.fullpath).to eq '/'
  end
  
  
# 　チェックボックスがオンの時、トークンが作られているか
  it "succeeds remember_token because of check remember_me" do
    get login_path
    post_valid_information(1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_nil
  end

# 　チェックボックスがオフの時、トークンが作られていないか
  it "has no remember_token because of check remember_me" do
    get login_path
    post_valid_information(0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
  end
  
# 　チェックボックスがオンの時、ログアウト後のログインでトークンが残っていないか
  it "has no remember_token when users logged out and logged in" do
    get login_path
    post_valid_information(1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_empty
    delete logout_path
    expect(is_logged_in?).to be_falsey
    expect(cookies[:remember_token]).to be_empty
  end
  
  
  
  #追加前のテスト
  describe "GET /login" do
    context "invalid information" do
      it "fails having a danger flash message" do
        get login_path
        post login_path, params: {
          session: {
            email: "",
            password: ""
          }
        }
        expect(flash[:danger]).to be_truthy
        expect(is_logged_in?).to be_falsey
      end
    end
    
    context "valid information" do
      it "succeeds having no danger flash message" do
        get login_path
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
        expect(flash[:danger]).to be_falsey
        expect(is_logged_in?).to be_truthy
      end
    

      it "succeeds login and logout" do
        get login_path
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
        expect(is_logged_in?).to be_truthy
        delete logout_path
        expect(is_logged_in?).to be_falsey
      end
    end
  end
end