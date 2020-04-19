require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do

  let(:user) { create(:user) }
  
  def post_invalid_information
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
  end
  
  # 10でのテスト
  # ログインのメソッド
  def post_valid_information(remember_me = 0)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me
      }
    }
  end
  
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