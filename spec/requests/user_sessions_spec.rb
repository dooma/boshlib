require 'spec_helper'

describe "UserSessions" do
  describe "GET /user_sessions" do
    it "should print form for log in" do
      visit new_user_sessions_path
      page.should have_content("Username")
      page.should have_content("Password")
      page.should have_content("Remember me")
    end
  end

  describe "POST /user_sessions" do
    it "should return error message if user does not exist" do
      visit new_user_sessions_path
      fill_in 'Username', :with => 'example@example.com'
      fill_in 'Password', :with => 'parola'
      click_button 'Login'

      page.should have_content('Login unsuccessful')
    end
  end
end
