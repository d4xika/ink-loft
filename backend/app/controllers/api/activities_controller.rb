class Api::ActivitiesController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    @activities = Activity.includes(user: { avatar_attachment: :blob })
                          .where(user: current_user.accepted_friend_ids)
                          .order(created_at: :desc)

    render json: @activities.map { |activity| render_activity(activity) }, status: :ok
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      return render json: @activity, status: :created
    else
      return render json: { errors: @activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def render_activity(activity)
    avatar_url = if activity.user.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        activity.user.avatar.variant(:small),
        host: Rails.env.production? ? "https://ink-loft.d4xika.com" : "http://127.0.0.1:3000"
      )
    end

    activity.as_json.merge(
      "username" => activity.user.username,
      "avatar_url" => avatar_url,
      "new" => current_user.last_activity_check.nil? || activity.created_at > current_user.last_activity_check
    )
  end

  def activity_params
    params.require(:activity).permit(:action, :description)
  end
end
