# frozen_string_literal: true

class UserSerializer < Panko::Serializer
  attributes :id, :first_name, :last_name, :username, :second_name

  has_many :posts, serializer: PostSerializer
  has_many :comments, serializer: CommentSerializer
end
