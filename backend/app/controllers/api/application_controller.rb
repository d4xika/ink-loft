class Api::ApplicationController < ActionController::Base
  include ActionController::Cookies

  protect_from_forgery with: :exception, prepend: true

  def current_user
    return @current_user if @current_user
    token_from_cookie = cookies.signed[:auth_token]

    if token_from_cookie
      auth_record = AuthKey.find_by(key: token_from_cookie)
      @current_user = auth_record&.user
    end
  end

  def authenticate_user!
    render json: { error: "Not authorized" }, status: :unauthorized unless current_user
  end

  def csrf_token
    render json: { csrf_token: form_authenticity_token }
  end
end