# frozen_string_literal: true

module Posts
  class LiteSerializer < Panko::Serializer
    attributes :id, :content, :comments_count
  end
end
