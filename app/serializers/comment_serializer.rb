# frozen_string_literal: true

class CommentSerializer < Panko::Serializer
  attributes :id, :content, :created_at, :updated_at

  has_one :author, serializer: UserSerializer
  has_many :replies, serializer: CommentLevel1Serializer

  def replies
    object.replies.order(created_at: :asc)
  end
end
