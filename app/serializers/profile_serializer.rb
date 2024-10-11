# frozen_string_literal: true

class ProfileSerializer < Panko::Serializer
  attributes :id, :email, :user

  def user
    Users::IndexSerializer.new.serialize(object.user)
  end
end
