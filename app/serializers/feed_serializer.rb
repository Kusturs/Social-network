class FeedSerializer < Panko::Serializer
  attributes :user_info, :feed_posts

  def user_info
    {
      followers_count: object[:user_info][:followers_count],
      following_count: object[:user_info][:following_count]
    }
  end

  def feed_posts
    object[:feed_posts].map do |post|
      {
        id: post.id,
        content: post.content,
        author: {
          id: post.author.id,
          username: post.author.username
        },
        created_at: post.created_at
      }
    end
  end
end
