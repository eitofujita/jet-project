class FeedQuery
  LIMIT = 30

  def initialize(user:)
    @user = user
  end

  def call
    followed_posts
      .or(Post.where(user: user))
      .with_attached_image
      .includes(:user, :likes, comments: :user)
      .recent
      .limit(LIMIT)
  end

  private

  attr_reader :user

  def followed_posts
    Post.where(
      user_id: Follow.where(follower: user).select(:followed_id)
    )
  end
end
