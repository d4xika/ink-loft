class Api::QuotesController < Api::ApplicationController
  before_action :authenticate_user!
  def index
    @quotes = current_user.quotes.includes(:book)

    return render json: @quotes.as_json(
      include: {
        book: {
          only: [ :id, :title, :author ]
        }
      },
    ), status: :ok
  end

  def daily_quote
    if current_user.quotes.empty?
      return render json: { message: "No quotes found" }, status: :ok
    end

    if params[:refresh]
      current_user.update_column(:daily_quote_seed, current_user.daily_quote_seed + 1)
    end

    rng = Random.new((Date.today.to_time.to_i + current_user.daily_quote_seed).to_i)
    @quote = current_user.quotes.order(created_at: :desc)[rng.rand(current_user.quotes.count)]
    @book = current_user.books.find(@quote.book_id)

    return render json: @quote.as_json.merge(
        book: {
          id: @book.id,
          title: @book.title,
          author: @book.author
        }
      ), status: :ok
  end

  def create
    @quote = current_user.quotes.build(quote_params)
    if @quote.save
      return render json: @quote, status: :created
    else
      return render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @quote = current_user.quotes.find(params[:id])
    if @quote.update(quote_params)
      return render json: @quote, status: :ok
    else
      return render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @quote = current_user.quotes.find(params[:id])
    @quote.destroy
    return render json: { message: "Quote deleted" }, status: :ok
  end

  private

  def quote_params
    params.require(:quote).permit(:content, :book_id)
  end
end