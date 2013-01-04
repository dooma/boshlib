class BooksController < ApplicationController
  before_filter :require_login

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = current_user.books.new(params[:book])

    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      flash[:alert] = "Can not create book"
      render action: "new"
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      redirect_to @book, notice: 'Book was successfully updated.'
    else
     flash.keep[:alert] = "Can not update book properties"    
     render action: "edit"
    end
  end

  def hire 
    user = current_user || User.find(params[:user_id]) # for tests or API
    @book = Book.find(params[:id])
    @hired_book = user.hired_books.new
    if @book.units > 0 and @book.hire_status == true
      @book.units = @book.units - 1
      @hired_book.book_id = @book.id
      @hired_book.expiration_time = Time.now + (60 * 60 * 24 * 14)
      @hired_book.user_id = params[:user_id]
      if @book.save and @hired_book.save
        redirect_to root_path, notice: 'You hired the book'
      else
        flash[:alert] = 'You can not hire this book'
        render :show
      end
    else 
      flash[:alert] = 'There are not enough books to hire'
    end
  end

  def buy
    @book = Book.find(params[:id])
    if @book.units > 0 and @book.hire_status == false
      @book.units = @book.units - 1
      if @book.save
        redirect_to root_path, notice: 'You bought the book'
      else
        flash[:alert] = 'You can not buy this book'
        render :show
      end
    else
      flash[:alert] = 'There are not enough books to sell'
      redirect_to root_path
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_url
  end
end
