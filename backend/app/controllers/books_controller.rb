class BooksController < ApplicationController
  before_action :authenticate_user!
  def show
    @book = current_user.books.find(params[:id])
    return render json: @book, status: :ok
  end

  def index
    @books = current_user.books
    return render json: @books, status: :ok
  end

  def create
    @book = current_user.books.build(book_params)
    @book.author = @book.author || "Unknown"
    if @book.save
      return render json: @book, status: :created
    else
      return render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @book = current_user.books.find(params[:id])
    if @book.update(book_params)
      return render json: @book, status: :ok
    else
      return render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def autocomplete
    @books = current_user.books.where("title ILIKE ?", "%#{params[:term]}%").limit(3)
    return render json: @books.map { |book| { id: book.id, title: book.title } }
  end

  def currently_reading
    @books = current_user.books.where(reading_status: :currently_reading).order(updated_at: :desc)
    return render json: @books, status: :ok
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :platform, :pairing, :cover_url, :chapters,
                                 :words, :pages, :start_date, :end_date, :rating, :recommended,
                                 :notes, :link, :reading_status)
  end
end
