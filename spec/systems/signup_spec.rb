require 'rails_helper'

RSpec.describe "Signups", type: :system do

  def submit_with_invalid_information
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'user@invalid'
    fill_in 'パスワード', with: 'foo'
    fill_in 'パスワード（再入力）', with: 'bar'
    find(".form-submit").click
  end

  def submit_with_valid_information
    fill_in '名前', with: 'Example User'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（再入力）', with: 'password'
    find(".form-submit").click
  end

  it "is invalid because it has no name" do
    visit signup_path
    submit_with_invalid_information
    expect(current_path).to eq signup_path
    expect(page).to have_selector '#error_explanation'
  end

  it "is valid because it fulfils form information" do
    visit signup_path
    submit_with_valid_information
    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert-info'
  end
end
