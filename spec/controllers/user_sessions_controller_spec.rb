require 'spec_helper'
describe UserSessionsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.activate!
  end
  it "should return 200" do
    get :new
    response.status.should eq(200)
  end

  it "should return 302" do
    post :create
    response.status.should eq(302)
  
    delete :destroy
    response.status.should eq(302)
  end

  it "should create session if user credentials are valid" do
    post :create, :username => @user.username, :password => "parola123", :remember_me => false
    response.should redirect_to(root_path)
    flash.now[:notice].should eq("Login successful")
    User.last.remember_me_token.should be_nil
  end

  it "should reject if credentials aren't valid" do
    post :create, :username => @user.username, :password => "", :remember_me => false
    response.should redirect_to(root_path)
    flash.now[:alert].should eq("Login unsuccessful")
  end

  it "should create remember token if user require it" do
    post :create, :username => @user.username, :password => "parola123", :remember_me => true
    response.should redirect_to(root_path)
    User.last.remember_me_token.should_not be_nil
  end

  it "should logout user without remember me" do
    post :create, :username => @user.username, :password => "parola123"
    response.status.should eq(302)
    delete :destroy
    response.status.should eq(302)
    response.should redirect_to(root_path)
    flash.now[:notice].should eq("Logout successful")
  end

  it "should logout user and delete remember me token " do
    post :create, :username => @user.username, :password => "parola123", :remember_me => true
    response.should redirect_to(root_path)
    User.last.remember_me_token.should_not be_nil

    delete :destroy
    User.last.remember_me_token.should be_nil
  end
end
