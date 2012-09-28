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
end
