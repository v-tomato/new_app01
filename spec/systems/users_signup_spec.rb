require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do

  it "is invalid because it has no name" do
    visit signup_path
    fill_in "名前", with: '', match: :first
    fill_in 'メールアドレス', with: 'user@invalid', match: :first
    fill_in 'パスワード', with: 'foo', match: :first
    fill_in 'パスワード（再入力）', with: 'bar', match: :first
    click_on '新規ユーザ作成', match: :first
    expect(current_path).to eq signup_path
    expect(page).to have_selector '#error_explanation'
    # expect(page).to have_selector 'li', text: '名前を入力してください'
  end
  
  it "is valid because it fulfils condition of input" do
      visit signup_path
      fill_in "名前", with: 'Example User', match: :first
      fill_in 'メールアドレス', with: 'user@example.com', match: :first
      fill_in 'パスワード', with: 'password', match: :first
      fill_in 'パスワード（再入力）', with: 'password', match: :first
      click_on '新規ユーザ作成', match: :first
      # follow_redirect!
      expect(current_path).to eq user_path(1)
      expect(page).not_to have_selector '#error_explanation'
  end  
end