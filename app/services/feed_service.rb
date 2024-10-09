class FeedService
  def initialize(user)
    @user = user
  end

  def call
    Post.includes(:user).where(user: @user.following).order(created_at: :desc)
  end
end

