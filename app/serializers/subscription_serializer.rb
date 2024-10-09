# frozen_string_literal: true

class SubscriptionSerializer < Panko::Serializer
  attributes :id, :created_at, :follower, :followed

  def follower
    UserSerializer.new.serialize(object.follower)
  end

  def followed
    UserSerializer.new.serialize(object.followed)
  end
end
