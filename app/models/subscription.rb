# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :follower, class_name: 'User', counter_cache: :followed_count
  belongs_to :followed, class_name: 'User', counter_cache: :followers_count

  validate :not_self_follow
  validates :follower_id, uniqueness: { scope: :followed_id, message: "already follows this user" }

  private

  def not_self_follow
    errors.add(:base, 'Cannot follow yourself') if follower_id == followed_id
  end
end
