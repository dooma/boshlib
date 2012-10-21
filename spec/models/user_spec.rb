describe User do
  before (:each) do
    @user = FactoryGirl.create(:user)
    @user.should be_valid
  end

  it "should validate password" do
    @user.password = "fo"
    @user.should_not be_valid

    @user.password = "foo@bar"
    @user.password_confirmation = "foo@beer"
    @user.should_not be_valid
  end

  it "should validate email uniqueness" do
    @user2 = FactoryGirl.create(:user, :email => "foo@beer.com", :username => "foo")
    @user2.should be_valid
    @user2.email = "test@test.com"
    @user2.should_not be_valid
  end

  it "should validate username" do
    @user2 = FactoryGirl.create(:user, :email => "foo@beer.com", :username => "foo")
    @user2.should be_valid

    @user2.username = "test"
    @user2.should_not be_valid

    @user2.username = ""
    @user2.should_not be_valid
  end
end
