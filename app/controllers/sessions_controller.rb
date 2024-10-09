# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json
  # skip_before_action :authenticate_profile!, only: [:create]
  # skip_before_action :verify_signed_out_user, only: :destroy

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: 'Logged in successfully.',
      profile: ProfileSerializer.new.serialize(resource)
    }
  end

  def respond_to_on_destroy
    render json: {
      message: 'Logged out successfully.'
    }, status: :ok
  end

  # def current_token
  #   request.env['warden-jwt_auth.token']
  # end
end
