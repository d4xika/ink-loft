class Api::FriendshipsController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    friendships = Friendship.involving(current_user)
                              .includes(:user_one, :user_two)
                              .order(updated_at: :desc)

    friends = friendships.accepted.map do |friendship|
      render_friend(friendship.other_user(current_user)).merge(id: friendship.id)
    end
    incoming_requests = friendships.pending
                                    .where.not(requested_by: current_user)
                                    .map do |friendship|
      render_friend(friendship.other_user(current_user)).merge(id: friendship.id)
    end
    outgoing_requests = friendships.pending
                                    .where(requested_by: current_user)
                                    .map do |friendship|
      render_friend(friendship.other_user(current_user)).merge(id: friendship.id)
    end

    render json: {
      friends: friends,
      incoming_requests: incoming_requests,
      outgoing_requests: outgoing_requests
    }, status: :ok
  end

  def create
    username = params[:username].to_s.strip
    friend = User.find_by(username: username)

    return render json: { error: "User not found" }, status: :not_found unless friend
    return render json: { error: "You cannot add yourself" }, status: :unprocessable_entity if friend == current_user

    existing_friendship = Friendship.between(current_user, friend)
    if existing_friendship
      message = existing_friendship.accepted? ? "You are already friends" : "A friend request already exists"
      return render json: { error: message }, status: :conflict
    end

    friendship = Friendship.request(current_user, friend)
    if friendship.persisted?
      render json: { message: "Friend request sent" }, status: :created
    else
      render json: { errors: friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    friendship = Friendship.involving(current_user).pending.find(params[:id])

    if friendship.requested_by_id == current_user.id
      return render json: { error: "You cannot accept your own request" }, status: :forbidden
    end

    friendship.accepted!
    render json: render_friend(friendship.other_user(current_user)), status: :ok
  end

  def destroy
    friendship = Friendship.involving(current_user).find(params[:id])

    unless friendship.accepted? || friendship.requested_by_id == current_user.id
      return render json: { error: "Only the sender can revoke this request" }, status: :forbidden
    end

    friendship.destroy!
    head :no_content
  end

  private

  def render_friend(user)
    base_url = Rails.env.production? ? "https://ink-loft.d4xika.com" : "http://127.0.0.1:3000"
    avatar_url = if user.avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:small), host: base_url)
    end

    { username: user.username, avatar_url: avatar_url }
  end
end
