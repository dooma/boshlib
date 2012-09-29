require 'spec_helper'

describe "Users" do
  
  before(:each) do
     @attr = { 
      :username => "foobar",
      :email => "foo@bar.com",
      :password => "passw123",
      :password_confirmation => "passw123"
    }
 end

  it "should response with 200 when access new_user_path" do
    get new_user_path
    response.status.should eq(200)
  end

  it "should response with 200 when access user_path" do
    @user = FactoryGirl.create(:user)
    @user.activate!
    get user_path(@user.id)
    response.status.should eq(302)
 end

  it "should show notice message" do
    visit new_user_path
    fill_in "Username", :with => @attr[:username]
    fill_in "Email", :with => @attr[:email]
    fill_in "Password", :with => @attr[:password]
    fill_in "Password confirmation", :with => @attr[:password_confirmation]
    click_button "Create User"
    page.should have_content("User was successfully created. Please activate email first")
  end

  it "should show error message if password is less 3 chars" do
    visit new_user_path
    fill_in "Username", :with => @attr[:username]
    fill_in "Email", :with => @attr[:email]
    fill_in "Password", :with => ""
    fill_in "Password confirmation", :with => ""
    click_button "Create User"
    page.should have_content("password must be at least 3 characters long")
  end

  it "should show error message if password doesn't match" do
    visit new_user_path
    fill_in "Username", :with => @attr[:username]
    fill_in "Email", :with => @attr[:email]
    fill_in "Password", :with => @attr[:password]
    fill_in "Password confirmation", :with => ""
    click_button "Create User"
    page.should have_content("should match confirmation")
  end

  it "should show user informations" do
    @user = FactoryGirl.create(:user)
    @user.activate!
    visit new_user_sessions_path
    fill_in "Username", :with => @user.username
    fill_in "Password", :with => "parola123"
    click_button "Login"
    page.should have_content("Sign out")
    visit user_path(@user.id)
    page.should have_content(@user.username)
    page.should have_content(@user.email)
  end
end
