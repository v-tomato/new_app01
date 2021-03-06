require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do  
  describe "home layout" do    
    it "contains root link" do
      visit root_path
      expect(page).to have_link nil, href: root_path, count: 1
    end 
  
   it "contains Help link" do
      visit root_path
      expect(page).to have_link 'Help', href: help_path
    end

    it "contains login link" do
      visit root_path
      expect(page).to have_link 'ログイン', href: login_path
    end
    
    it "contains about link" do
      visit root_path
      expect(page).to have_link 'About', href: about_path
    end
    
    it "contains 登録して始めよう link" do
      visit root_path
      expect(page).to have_link '登録して始めよう'
    end
  end
  
end