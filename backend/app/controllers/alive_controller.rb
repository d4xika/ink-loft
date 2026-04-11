class AliveController < ApplicationController
  def alive
    render json: { message: "Server is alive" }, status: :ok
  end
end
