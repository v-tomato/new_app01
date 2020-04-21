require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def patch_invalid_information
    patch user_path(user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end
  
   def patch_valid_information
    patch user_path(user), params: {
      user: {
        name: "name",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
  end

  describe "GET /users/:id/edit" do
    context "invalid" do
      # 有効でない編集情報
      it "is invalid edit informaiton" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy
        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'
        patch_invalid_information
        expect(flash[:danger]).to be_truthy
        expect(request.fullpath).to eq '/users/1'
      end
      
      # ログインを促す11
      it "is invalid because of having not log in" do
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
      
      #異なるユーザーがログインし、有効ではない
      it "is invalid because of having log in as wrong user" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
    
    context "valid" do
      # 有効な編集情報の場合
      it "is valid edit information" do
        log_in_as(user)
        get edit_user_path(user)
        patch_valid_information
        # expect(flash[:success]).to be_truthy 要確認
        follow_redirect!
        expect(request.fullpath).to eq '/users/1/edit'
      end
      
      # 異なるユーザーの為、update(編集ページ)にリダイレクトされない
      it "does not redirect update because of having log in as wrong user" do
        log_in_as(other_user)
        get edit_user_path(user)
        patch_valid_information
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
      
      # 編集ページにリダイレクトするテスト
      # 正しいユーザーがログインした為、前のリンクへ（編集ページ）
      it "goes to previous link because they had logged in as right user" do
       get edit_user_path(user)
       follow_redirect!
       expect(request.fullpath).to eq '/login'
       log_in_as(user)
       expect(request.fullpath).to eq '/users/1/edit'
      end
    end
  end
  
end
