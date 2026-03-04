module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      private

      def authenticate_user!
        token = request.headers["Authorization"]&.split(" ")&.last
        payload = JwtHelper.decode(token) if token
        @current_user = User.find_by(id: payload[:user_id]) if payload
        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
