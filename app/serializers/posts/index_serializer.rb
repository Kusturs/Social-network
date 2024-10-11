# frozen_string_literal: true

module Posts
  class IndexSerializer < Panko::Serializer
    attributes :id, :content, :comments_count

    has_one :author, serializer: UserSerializer

    delegate :comments_count, to: :object
  end
end
