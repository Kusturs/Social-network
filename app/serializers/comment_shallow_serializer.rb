# frozen_string_literal: true

class CommentShallowSerializer < Panko::Serializer
  attributes :id, :content, :created_at, :updated_at
end
