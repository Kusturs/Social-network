# frozen_string_literal: true

class FeedSerializer < Panko::Serializer
  attributes :id, :title, :content, :created_at, :updated_at

  has_one :author, serializer: UserSerializer
end
