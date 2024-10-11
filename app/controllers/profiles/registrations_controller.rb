# frozen_string_literal: true

module Profiles
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json

    def create
      ActiveRecord::Base.transaction do
        build_resource(sign_up_params)
        resource.build_user(user_params)
        resource.save!
        sign_up(resource_name, resource)
      end

      render json: {
        message: 'Signed up successfully.',
        profile: ProfileSerializer.new.serialize(resource)
      }, status: :created
    rescue ActiveRecord::RecordInvalid
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def sign_up_params
      params.require(:profile).permit(:email, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name)
    end
  end
end
