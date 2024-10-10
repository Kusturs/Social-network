# frozen_string_literal: true

class FeedService
  def initialize(user)
    @user = user
  end

  def call
    {
      user_info: user_info,
      feed_posts: feed_posts
    }
  end

  private

  def user_info
    {
      followers_count: @user.followers_count,
      following_count: @user.followed_count
    }
  end

  def feed_posts
    following_ids = @user.active_subscriptions.pluck(:followed_id)
    Post.includes(:author).where(author_id: following_ids).order(created_at: :desc)
  end
end
