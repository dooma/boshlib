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
    @book = Book.new(params[:book])

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
    @book = Book.find(params[:id])
    @hired_book = HiredBook.new
    if @book.units
      @book.units = @book.units - 1
      @hired_book.book_id = @book.id
      @hired_book.expiration_time = Time.now + (60 * 60 * 24 * 14)
      
      if @book.save and @hired_book.save
        redirect_to root_path, notice: 'You hired the book'
      else
        flash[:alert] = 'You can not hire this book'
        render :show
      end
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_url
  end
end
