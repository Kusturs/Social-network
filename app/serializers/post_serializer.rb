# frozen_string_literal: true

class PostSerializer < Panko::Serializer
  attributes :id, :content

  has_one :author, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer
end
