class Api::UsersController < Api::ApplicationController
  skip_forgery_protection only: [ :login, :register ]
  before_action :authenticate_user!, only: [ :updates_state, :mark_updates_read, :update_quotes_share_with_friends, :update_last_activity_check ]

  def login
    user = User.find_by(username: params[:username])
    if !user || !user.authenticate(params[:password])
      return render json: { error: "Wrong email or password" }, status: :unauthorized
    end

    auth_key = user.generate_auth_key

    cookies.signed[:auth_token] = {
      value: auth_key.key,
      httponly: true,
      expires: 1.month.from_now,
      same_site: :lax,
      secure: Rails.env.production?
    }
    return render json: render_user(user).merge(csrf_token: form_authenticity_token), status: :ok
  end

  def is_logged_in
    if current_user
      render json: { authenticated: true, user: render_user(current_user), csrf_token: form_authenticity_token }, status: :ok
    else
      render json: { authenticated: false }, status: :ok
    end
  end

  def logout
    token = cookies.signed[:auth_token]

    if token
      auth_record = AuthKey.find_by(key: token)
      auth_record.destroy if auth_record
    end

    cookies.delete(:auth_token,
                   same_site: Rails.env.production? ? :none : :lax,
                   secure: Rails.env.production?
    )

    head(:ok)
  end

  def register
    if User.find_by(username: params[:username]) || User.find_by(email: params[:email])
      return render json: { error: "User already exists" }, status: :conflict
    end

    user = User.create(username: params[:username], email: params[:email], password: params[:password])
    auth_key = user.generate_auth_key

    cookies.signed[:auth_token] = {
      value: auth_key.key,
      httponly: true,
      expires: 1.month.from_now,
      same_site: :lax,
      secure: Rails.env.production?
    }

    return render json: render_user(user).merge(csrf_token: form_authenticity_token), status: :created
  end

  def update_profile
    user = current_user

    if account_update_params.present?
      unless params[:current_password].present? && user.authenticate(params[:current_password])
        return render json: { error: "Current password is incorrect" }, status: :forbidden
      end

      account_params = account_update_params

      user.assign_attributes(account_params)
    end

    if params[:delete_avatar] == "true"
      user.avatar.purge
    elsif params[:avatar].present?
      user.avatar.attach(params[:avatar])
    end

    if params[:language].present?
      if User.languages.key?(params[:language])
        user.language = params[:language]
      else
        return render json: { error: "Invalid language" }, status: :bad_request
      end
    end

    if params[:theme].present?
      if User.themes.key?(params[:theme])
        user.theme = params[:theme]
      else
        return render json: { error: "Invalid theme" }, status: :bad_request
      end
    end

    if user.save
      if account_update_params["password"].present?
        user.auth_keys.destroy_all
        auth_key = user.generate_auth_key
        cookies.signed[:auth_token] = {
          value: auth_key.key,
          httponly: true,
          expires: 1.month.from_now,
          same_site: :lax,
          secure: Rails.env.production?
        }
      end

      return render json: {
        user: render_user(user),
        csrf_token: form_authenticity_token
      }, status: :ok
    else
      return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { error: "Username or email already exists" }, status: :conflict
  end

  def updates_state
    render json: { updates_seen_count: current_user.updates_seen_count }
  end

  def mark_updates_read
    updates_seen_count = Integer(params[:updates_seen_count], exception: false)

    if updates_seen_count.nil? || updates_seen_count.negative?
      return render json: { error: "Invalid updates seen count" }, status: :bad_request
    end

    current_count = current_user.updates_seen_count || 0
    current_user.update!(updates_seen_count: [ current_count, updates_seen_count ].max)

    render json: { updates_seen_count: current_user.updates_seen_count }
  end

  def update_quotes_share_with_friends
    requested_user_ids = Array(params[:quotes_share_with_friends]).filter_map do |user_id|
      Integer(user_id, exception: false)
    end
    current_user.update!(
      quotes_share_with_friends: requested_user_ids & current_user.accepted_friend_ids
    )
    render json: { quotes_share_with_friends: current_user.quotes_share_with_friends }
  end

  def update_last_activity_check
    current_user.update!(last_activity_check: Time.current)
    render json: { last_activity_check: current_user.last_activity_check }, status: :ok
  end

  private

  def account_update_params
    params.permit(:username, :email, :password)
         .to_h
         .compact
         .reject { |key, value| key == "password" && value.blank? }
  end

  def render_user(user)
    base_url = Rails.env.production? ? "https://ink-loft.d4xika.com" : "http://127.0.0.1:3000"
    avatar_url_small = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:small), host: base_url) : nil
    avatar_url_medium = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:medium), host: base_url) : nil
    avatar_url_large = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:large), host: base_url) : nil

    return {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_url: { small: avatar_url_small, medium: avatar_url_medium, large: avatar_url_large },
      language: user.language,
      quotes_share_with_friends: user.quotes_share_with_friends,
      last_activity_check: user.last_activity_check,
      theme: user.theme
    }
  end
end
