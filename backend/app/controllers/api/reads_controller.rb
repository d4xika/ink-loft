class Api::ReadsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_read_user, only: [ :index, :show, :currently_reading ]

  def show
    @read = @read_user.reads.find(params[:id])
    @quotes = @read.quotes.order(created_at: :desc).select(:id, :content)
    return render json: @read.as_json.merge(quotes: @quotes), status: :ok
  end

  def index
    if params[:reading_status] && Read.reading_statuses.keys.include?(params[:reading_status])
      @reads = @read_user.reads.where(reading_status: params[:reading_status]).order(start_date: :desc, updated_at: :desc)
    else
      @reads = @read_user.reads
    end

    if params[:search].present?
      search = ActiveRecord::Base.sanitize_sql_like(params[:search].to_s.strip)
      @reads = @reads.where("title ILIKE :search OR author ILIKE :search", search: "%#{search}%")
    end

    return render json: @reads, status: :ok
  end

  def create
    @read = current_user.reads.build(read_params)
    @read.author = @read.author.presence || "Unknown"
    if @read.save
      return render json: @read, status: :created
    else
      return render json: { errors: @read.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @read = current_user.reads.find(params[:id])
    if params[:remove_cover] == "true"
      @read.cover.purge
    end

    if @read.update(read_params)
      return render json: @read, status: :ok
    else
      return render json: { errors: @read.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @read = current_user.reads.find(params[:id])
    @read.quotes.destroy_all
    @read.destroy
    return render json: { message: "Read deleted successfully" }, status: :ok
  end

  def autocomplete
    @reads = current_user.reads.where("title ILIKE ?", "%#{params[:term]}%").limit(3)
    return render json: @reads.map { |read| { id: read.id, title: read.title } }
  end

  def currently_reading
    @reads = @read_user.reads.where(reading_status: :currently_reading).order(updated_at: :desc)

    return render json: @reads, status: :ok
  end

  private

  def set_read_user
    @read_user = readable_user(params[:username])
    render json: { error: "User not found or not a friend" }, status: :not_found unless @read_user
  end

  def read_params
    read_params = params[:read]
    if read_params.is_a?(String)
      read_params = JSON.parse(read_params)
    end

    if params[:cover].present? && read_params.is_a?(Hash)
      read_params[:cover] = params[:cover]
    end

    if read_params.is_a?(Hash)
      params_to_permit = ActionController::Parameters.new(read: read_params)
      params_to_permit.require(:read).permit(:title, :author, :platform, :pairing, :cover, :chapters,
                                             :words, :pages, :start_date, :end_date, :rating, :recommended,
                                             :notes, :link, :song, :reading_status, :current_progress, :progress_type)
    else
      params.require(:read).permit(:title, :author, :platform, :pairing, :cover, :chapters,
                                   :words, :pages, :start_date, :end_date, :rating, :recommended,
                                   :notes, :link, :song, :reading_status, :current_progress, :progress_type)
    end
  end
end
