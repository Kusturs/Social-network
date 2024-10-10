# frozen_string_literal: true

module Profiles
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json

    def create
      build_resource(sign_up_params)
      resource.build_user(user_params)
      resource.save
      if resource.persisted?
        sign_up(resource_name, resource)
        render json: {
          message: 'Signed up successfully.',
          profile: ProfileSerializer.new.serialize(resource)
        }, status: :created
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
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
