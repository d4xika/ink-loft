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
      @reads = @read_user.reads.where(reading_status: params[:reading_status])
    else
      @reads = @read_user.reads
    end

    if params[:search].present?
      search = ActiveRecord::Base.sanitize_sql_like(params[:search].to_s.strip)
      @reads = @reads.where("title ILIKE :search OR author ILIKE :search", search: "%#{search}%")
    end

    @reads = apply_sort(@reads)

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

  def apply_sort(reads)
    sort_by = params[:sort_by].presence_in(%w[title author pairing date chapters pages words]) || "date"
    direction = params[:sort_direction].to_s.in?(%w[asc desc]) ? params[:sort_direction] : "desc"
    column = sort_by == "date" ? "start_date" : sort_by
    numeric_sort = sort_by.in?(%w[chapters pages words])

    missing_value = if sort_by == "date" || numeric_sort
                      "#{column} IS NULL"
                    else
                      "NULLIF(TRIM(#{column}), '') IS NULL"
                    end
    sorted_value = sort_by == "date" || numeric_sort ? column : "LOWER(#{column})"

    reads.order(
      Arel.sql("CASE WHEN #{missing_value} THEN 1 ELSE 0 END ASC"),
      Arel.sql("#{sorted_value} #{direction.upcase} NULLS LAST"),
      Arel.sql("LOWER(title) ASC"),
    )
  end
end
