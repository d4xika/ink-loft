class Api::UsersController < Api::ApplicationController
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
    return render json: render_user(user), status: :ok
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

    return render json: render_user(user), status: :created
  end

  def update_profile
    user = current_user

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

    if user.save
      return render json: {
        user: render_user(user)
      }, status: :ok
    else
      return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def render_user(user)
    base_url = Rails.env.production? ? "https://ink-loft.d4xika.com" : "http://127.0.0.1:3000"
    avatar_url_small = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:small), host: base_url) : nil
    avatar_url_medium = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:medium), host: base_url) : nil
    avatar_url_large = user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar.variant(:large), host: base_url) : nil

    return {
      username: user.username,
      avatar_url: { small: avatar_url_small, medium: avatar_url_medium, large: avatar_url_large },
      language: user.language
    }
  end
end
