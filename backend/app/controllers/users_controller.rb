class UsersController < ApplicationController
  def login
    user = User.find_by(username: params[:username])
    if !user || !user.authenticate(params[:password])
      return render json: { error: "Wrong email or password" }, status: :unauthorized
    end

    auth_key = user.generate_auth_key
    return render_user_with_auth(user, auth_key)
  end

  def register
    if User.find_by(username: params[:username]) || User.find_by(email: params[:email])
      return render json: { error: "User already exists" }, status: :conflict
    end

    user = User.create(username: params[:username], email: params[:email], password: params[:password])
    auth_key = user.generate_auth_key

    return render_user_with_auth(user, auth_key)
  end

  private

  def render_user_with_auth(user, auth_key)
    render json: { user: user, auth_key: auth_key }, status: :ok
  end
end