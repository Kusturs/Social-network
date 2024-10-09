# frozen_string_literal: true

module Profiles
  class SessionsController < Devise::SessionsController
    respond_to :json
    # skip_before_action :authenticate_profile!, only: [:create]
    # skip_before_action :verify_signed_out_user, only: :destroy

    private

    def respond_with(_resource, _opts = {})
      render json: {
        message: 'Logged in successfully.',
        token: current_token
      }
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last,
                                 Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
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
