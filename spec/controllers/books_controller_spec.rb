require 'spec_helper'

describe BooksController do
  before (:each) do
    login_user(@user = FactoryGirl.create(:user))
    @book = FactoryGirl.create(:book)
  end

  describe "GET methods" do
    it "should respond 200" do
      get :index
      response.status.should eq(200)

      get :new
      response.status.should eq(200)
      
      book = Book.new(:title => "xzf", :description => "y", :price => "12", :hire_status => true, :units => 1)
      book.save if book.valid?
      get :show, :id => book.id
      response.status.should eq(200)
    end
  end

  describe "POST methods" do
    it "should create new book in database" do
      post :create, :book => { :title => "xzf", 
                              :description => "y", 
                              :price => "12", 
                              :hire_status => true, 
                              :units => 2 }
      book = Book.last
      book.title.should eq("xzf")
      book.description.should eq("y")
      book.price.should eq("12")
      response.should redirect_to(book)
      flash.now[:notice].should eq('Book was successfully created.')
    end

    it "should render new page if book can't be saved" do
      @book.destroy
      post :create, :book => {  :title => "x", :description => "y"}
      Book.all.should be_empty
      response.should render_template(:new)
    end

    it "should rent a book if are enough" do
      # make sure does exist minimum 1 book
      if @book.units == 0
        @book.units = 1
        @book.save if @book.valid?
      end
      post :hire, :id => @book.id, :user_id => @user.id
      Book.find(@book.id).units.should eq(0)
    end

    it "should buy a book if are enough" do
      # make sure does exist minimum 1 book
      if @book.hire_status == true
        @book.hire_status = false
        @book.save if @book.valid?
      end
      if @book.units == 0
        @book.units = 1
        @book.save if @book.valid?
      end
      post :buy, :id => @book.id
      Book.last.units.should eq(0)
      flash.now[:notice].should eq('You bought the book')
    end

    it "should print alert message if there are not enough books" do
      @book.units = 0
      @book.save if @book.valid?
      post :buy, :id => @book.id
      flash.now[:alert].should eq('There are not enough books to sell')
      # should be 0. Not decremented.
      Book.last.units.should eq(0)
    end
  end

  describe "PUT methods" do
    it "should update book properties" do
      put :update, :id => @book.id, :book => {:title => "znoob"}
      book = Book.find(@book.id)
      book.title.should eq("znoob")
      response.should redirect_to(book)
      flash.now[:notice].should eq('Book was successfully updated.')
    end

    it "should render edit page if book can't be updated" do
      put :update, :id => @book.id, :book => {:title => ""}
      book = Book.find(@book.id)
      book.title.should_not be_nil
      book.title.should eq("Romeo&Julieta")
      response.should render_template(:edit)
    end
  end

  describe "DELETE methods" do
    it "should destroy book" do
      post :create, :book => {:title => "xzf", :description => "y", :price => "12"}
      delete :destroy, :id => Book.last.id
    end
  end
end
