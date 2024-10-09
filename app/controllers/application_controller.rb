# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  include ActionController::MimeResponds
  include Devise::Controllers::Helpers

  respond_to :json

  rescue_from JWT::DecodeError, with: :invalid_token

  private

  def invalid_token
    render json: { error: 'Invalid token' }, status: :unauthorized
  end

  def authenticate_profile!
    return if profile_signed_in?

    render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
  end
end
