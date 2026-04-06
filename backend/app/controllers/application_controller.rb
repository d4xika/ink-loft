class ApplicationController < ActionController::API
  include ActionController::Cookies

  def current_user
    token = cookies.signed[:auth_token]
    @current_user ||= User.find_by(auth_key: token) if token
  end

  def authenticate_user!
    render json: { error: "Not authorized" }, status: :unauthorized unless current_user
  end
end
