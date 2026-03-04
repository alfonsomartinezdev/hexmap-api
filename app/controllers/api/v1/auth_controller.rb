module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.new(name: params[:name], password: params[:password])

        if user.save
          token = JwtHelper.encode(user.id)
          render json: { token: token, user: user_json(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(name: params[:name])

        if user&.authenticate(params[:password])
          token = JwtHelper.encode(user.id)
          render json: { token: token, user: user_json(user) }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      def logout
        head :no_content
      end

      private

      def user_json(user)
        { id: user.id, name: user.name }
      end
    end
  end
end
