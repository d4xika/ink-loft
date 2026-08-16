class Api::QuotesController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_quote_user, only: [ :index, :daily_quote ]

  def index
    @quotes = @quote_user.quotes.includes(:read)

    return render json: @quotes.as_json(
      include: {
        read: {
          only: [ :id, :title, :author ]
        }
      },
    ), status: :ok
  end

  def daily_quote
    if @quote_user.quotes.empty?
      return render json: { message: "No quotes found" }, status: :ok
    end

    if params[:refresh] && @quote_user == current_user
      current_user.update_column(:daily_quote_seed, current_user.daily_quote_seed + 1)
    end

    rng = Random.new((Date.today.to_time.to_i + @quote_user.daily_quote_seed).to_i)
    @quote = @quote_user.quotes.order(created_at: :desc)[rng.rand(@quote_user.quotes.count)]
    @read = @quote_user.reads.find(@quote.read_id)

    return render json: @quote.as_json.merge(
        read: {
          id: @read.id,
          title: @read.title,
          author: @read.author
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

  def set_quote_user
    @quote_user = readable_user(params[:username])
    render json: { error: "User not found or not a friend" }, status: :not_found unless @quote_user
  end

  def quote_params
    params.require(:quote).permit(:content, :read_id)
  end
end
