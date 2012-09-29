require 'spec_helper'

describe UsersController do
  
  before(:each) do
    @attr = { 
      :username => "foobar",
      :email => "foo@bar.com",
      :password => "passw123",
      :password_confirmation => "passw123"
    }
  end

  describe "Test require_login filter" do
    it "should require login" do
      user = FactoryGirl.create(:user)
      get :show, :id => user.id
      response.should redirect_to(root_path)
    end
    it "should require login" do
      user = FactoryGirl.create(:user)
      delete :destroy, :id => user.id
      response.should redirect_to(root_path)
    end
  end
  
  it "should get 200" do
    get :new
    response.status.should eq(200)
  end

  it "should notice if user is created" do
    post :create, :user => @attr
    flash.now[:notice].should eq("User was successfully created. Please activate email first!")
    response.should redirect_to(root_path)
    user = User.last
    user.should_not be_nil
    user.username.should eq('foobar')
    user.activation_state.should eq('pending')
    user.email.should eq('foo@bar.com')
  end

  it "should render :new method if user can't be saved" do
    post :create, :user => @attr.merge(:username => "")
    response.should render_template('new')
    
    post :create, :user => @attr.merge(:password_confirmation => "")
    response.should render_template('new')
  end

  it "should activate user if token is correct" do
    @user = User.new(@attr)
    @user.save if @user.valid?
    @user.activation_token.should_not be_nil
    @user.activation_state.should eq("pending")
    
    post :activate, :id => @user.activation_token
    flash.now[:notice].should eq("Activation successfully")
    response.should redirect_to(root_path)

    user = User.where(:username => "foobar").first
    user.activation_token.should be_nil
    user.activation_state.should eq("active")
  end

  it "should redirect and show message if user can't be activated" do
    @user = User.new(@attr)
    @user.save if @user.valid?
    token = @user.activation_token
    @user.activate!
    @user.activation_state.should eq("active")
    @user.activation_token.should be_nil
    
    post :activate, :id => token
    flash.now[:alert].should eq("Account can not be activated")
    response.should redirect_to(root_path)

    # If user does not exist
    post :activate, :id => BCrypt::Password.create(Time.now)
    flash.now[:alert].should eq("Account can not be activated")
    response.should redirect_to(root_path)
  end
end
