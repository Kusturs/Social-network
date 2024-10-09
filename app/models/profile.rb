# frozen_string_literal: true

class Profile < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :user

  # before_create :set_jti

  # def jwt_payload
  #   super.merge('profile_id' => id)
  # end

  # private

  # def set_jti
  #   self.jti ||= SecureRandom.uuid
  # end
end
