class UsersController < ApplicationController
  def login
    user = User.find_by(username: params[:username])
    if !user || !user.authenticate(params[:password])
      return render json: { error: "Wrong email or password" }, status: :unauthorized
    end

    auth_key = user.generate_auth_key

    cookies.signed[:auth_token] = {
      value: auth_key,
      httponly: true,
      expires: 2.weeks.from_now,
      same_site: :lax,
      secure: Rails.env.production?
    }
    return render json: { username: user.username }, status: :ok
  end

  def register
    if User.find_by(username: params[:username]) || User.find_by(email: params[:email])
      return render json: { error: "User already exists" }, status: :conflict
    end

    user = User.create(username: params[:username], email: params[:email], password: params[:password])
    auth_key = user.generate_auth_key

    cookies.signed[:auth_token] = {
      value: auth_key,
      httponly: true,
      expires: 2.weeks.from_now,
      same_site: :lax,
      secure: Rails.env.production?
    }

    return render json: { username: user.username }, status: :created
  end
end