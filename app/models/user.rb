# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy, inverse_of: :author

  has_many :follower_subscriptions, class_name: 'Subscription', foreign_key: 'followed_id', inverse_of: :followed
  has_many :followers, through: :follower_subscriptions, source: :follower, inverse_of: :followed_users

  has_many :followed_subscriptions, class_name: 'Subscription', foreign_key: 'follower_id', inverse_of: :follower
  has_many :followed_users, through: :followed_subscriptions, source: :followed, inverse_of: :followers

  validates :first_name, :last_name, :username, presence: true, on: :create

  validates :first_name, presence: true, on: :update, if: :first_name_changed?

  validates :last_name, presence: true, on: :update, if: :last_name_changed?

  validates :username, presence: true, on: :update, if: :username_changed?
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'only allows letters, numbers, and underscores' },
                       length: { in: 3..20 },
                       if: :username_present?

  def follow(user)
    followed_users << user unless self == user
  end

  def unfollow(user)
    followed_users.delete(user)
  end

  def following?(user)
    followed_users.include?(user)
  end

  private

  def username_present?
    username.present?
  end
end
