class CommentLevel1Serializer < Panko::Serializer
  attributes :id, :content, :created_at, :updated_at

  has_one :author, serializer: UserSerializer
  has_many :replies, serializer: CommentShallowSerializer

  def replies
    object.replies.order(created_at: :asc)
  end
end
