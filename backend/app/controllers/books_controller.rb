class BooksController < ApplicationController
  before_action :authenticate_user!
  def show
    @book = current_user.books.find_by(title: params[:title])
    return render json: @book, status: :ok
  end

  def index
    @books = current_user.books
    return render json: @books, status: :ok
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      return render json: @book, status: :created
    else
      return render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :platform, :pairing, :cover_url, :chapters,
                                 :words, :pages, :start_date, :end_date, :rating, :recommended,
                                 :notes, :link, :reading_status)
  end
end
