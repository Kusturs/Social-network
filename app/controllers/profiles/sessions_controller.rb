# frozen_string_literal: true

module Profiles
  class SessionsController < Devise::SessionsController
    include RackSessionsFix
    respond_to :json

    private

    def respond_with(_resource, _opts = {})
      render json: {
        message: 'Logged in successfully.',
        token: current_token
      }
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        payload = JWT.decode(request.headers['Authorization'].split(' ').last,
                             Rails.application.credentials.fetch(:secret_key_base)).first
        # current_user = User.find_by(id: payload['sub'])
        current_profile = Profile.find_by(id: payload['sub'])
      end

      if current_profile
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end
  end
end
