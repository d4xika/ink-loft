class QuotesController < ApplicationController
  before_action :authenticate_user!
  def index
    @quotes = current_user.quotes
    return render json: @quotes, status: :ok
  end

  def create
    @quote = current_user.quotes.build(quote_params)
    if @quote.save
      return render json: @quote, status: :created
    else
      return render json: { errors: @quote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def quote_params
    params.require(:quote).permit(:content, :book_id)
  end
end