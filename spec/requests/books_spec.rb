require 'spec_helper'

describe "Books" do
  before (:each) do
    @book = FactoryGirl.create(:book)
    
    # create user session
    @user = FactoryGirl.create(:user)
    @user.activate!
    visit new_user_sessions_path
    fill_in "Username", :with => @user.username
    fill_in "Password", :with => "parola123" 
    click_button 'Login'
    page.should have_content("Login successful")
  end

  describe "access pages" do
    it "should respond with 302" do
      get books_path
      response.status.should eq(302)

      get new_book_path
      response.status.should eq(302)

      get edit_book_path(@book.id)
      response.status.should eq(302)

      put book_path(@book.id)
      response.status.should eq(302)

      post books_path, :book => {:title => "xzf", :description => "description", :price => "14"}
      response.status.should eq(302)

      delete book_path(@book.id)
      response.status.should eq(302)
    end
  end

  describe "verify pages content" do
    it "should print correct books_index page" do
      visit books_path
      page.should have_content("Listing books")
      page.should have_content("Romeo&Julieta")
      page.should have_content("William Shakespeare")
      page.should have_content("200")
    end

    it "should print additional book informations page" do
      visit book_path(@book.id)
      page.should have_content("A story about love")
      page.should have_content("1923")
      page.should have_content("Edit")
      page.should have_content("Back")
    end

    it "should can edit a book" do
      visit edit_book_path(@book.id)
      page.should have_content("Title")
      page.should have_content("Description")
      page.should have_content("Price")
    end
  end

  describe "test page links" do
    it "should update book properties" do
      visit edit_book_path(@book.id)

      # Edit part
      fill_in "Title", :with => "Iliad"
      fill_in "Author", :with => "Homer"
      fill_in "Price", :with => "12"
      fill_in "Description", :with => "Another story"
      click_button "Update Book"

      book = Book.last
      book.title.should eq("Iliad")
      book.author.should eq("Homer")
      book.price.should eq("12")
      book.description.should eq("Another story")
    end

    it "should show book page" do
      visit books_path
      page.should have_content("Show")
      click_link "Show"
      page.should have_content(@book.title)
    end
  end

  describe "verify flash messages" do
    it "should print error messages if can't create book" do
      visit new_book_path
      fill_in "Title", :with => "Iliad"
      fill_in "Author", :with => "Homer"
      click_button "Create Book"
      page.should have_content("Can not create book")
    end

    it "should print error messages if can't edit book" do
      visit edit_book_path(@book.id)
      fill_in "Title", :with => ""
      click_button "Update Book"
      page.should have_content("Can not update book properties")
    end
  end
end
