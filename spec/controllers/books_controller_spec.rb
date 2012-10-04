require 'spec_helper'
describe BooksController do
  describe "GET methods" do
    it "should respond 200" do
      get :index
      response.status.should eq(200)

      get :new
      response.status.should eq(200)
      
      book = Book.new(:title => "x", :description => "y", :price => "12")
      book.save if book.valid?
      get :show, :id => book.id
      response.status.should eq(200)
    end
  end
  describe "POST methods" do
    it "should create new book in database" do
      post :create, :book => {:title => "x", :description => "y", :price => "12"}
      book = Book.last
      book.title.should eq("x")
      book.description.should eq("y")
      book.price.should eq("12")
      response.should redirect_to(book)
      flash.now[:notice].should eq('Book was successfully created.')
    end

    it "should render page if book can't be saved" do
      post :create, :book => {:title => "x", :description => "y"}
      Book.all.should be_empty
      response.should render_template(:new)#"new")
    end
  end
end
