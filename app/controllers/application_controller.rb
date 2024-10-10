# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  include ActionController::MimeResponds
  include Devise::Controllers::Helpers

  respond_to :json

  rescue_from JWT::DecodeError, with: :invalid_token

  private

  def authenticate_user!
    if request.headers['Authorization'].present?
      bearer_token = request.headers['Authorization'].split(' ').last
      signature = Rails.application.credentials.secret_key_base
      jwt_payload = JWT.decode(bearer_token, signature).first

      @current_user_id = jwt_payload['sub']
    end

    render json: { errors: 'Not Authorized' }, status: :unauthorized unless signed_in?
  end

  def signed_in?
    @current_user_id.present?
  end

  def current_user
    @current_user ||= User.find(@current_user_id)
  end

  def invalid_token
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end
