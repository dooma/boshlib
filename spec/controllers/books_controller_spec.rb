require 'spec_helper'
describe BooksController do
  describe "GET methods" do
    it "should respond 200" do
      get :index
      response.status.should eq(200)

      get :new
      response.status.should eq(200)
      
      book = Book.new(:title => "xzf", :description => "y", :price => "12")
      book.save if book.valid?
      get :show, :id => book.id
      response.status.should eq(200)
    end
  end

  describe "POST methods" do
    it "should create new book in database" do
      post :create, :book => {:title => "xzf", :description => "y", :price => "12"}
      book = Book.last
      book.title.should eq("xzf")
      book.description.should eq("y")
      book.price.should eq("12")
      response.should redirect_to(book)
      flash.now[:notice].should eq('Book was successfully created.')
    end

    it "should render new page if book can't be saved" do
      post :create, :book => {:title => "x", :description => "y"}
      Book.all.should be_empty
      response.should render_template(:new)
    end

    it "should update book properties" do
      post :create, :book => {:title => "xzf", :description => "y", :price => "12"}
      book = Book.last
      book.title.should eq("xzf")
      post :update, :id => book.id, :book => {:title => "znoob"}
      book = Book.last
      book.title.should eq("znoob")
      response.should redirect_to(book)
      flash.now[:notice].should eq('Book was successfully updated.')
    end

    it "should render edit page if book can't be updated" do
      post :create, :book => {:title => "xzf", :description => "yzf", :price => "12"}
      book = Book.last
      book.title.should eq("xzf")
      post :update, :id => book.id, :book => {:title => ""}
      book = Book.last
      book.title.should_not be_nil
      book.title.should eq("xzf")
      response.should render_template(:edit)
    end
  end

  describe "PUT methods" do
    it "should destroy book" do
      post :create, :book => {:title => "xzf", :description => "y", :price => "12"}
      put :destroy, :id => Book.last.id
    end
  end
end
