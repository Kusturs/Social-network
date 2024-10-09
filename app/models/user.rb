# frozen_string_literal: true

class User < ApplicationRecord
  has_one :profile, dependent: :destroy
<<<<<<< HEAD
=======

  has_many :posts, foreign_key: 'author_id', inverse_of: :author, dependent: :destroy
  has_many :comments, dependent: :destroy
>>>>>>> 1218541 (np)

  has_many :posts, foreign_key: 'author_id', inverse_of: :author, dependent: :destroy
  has_many :comments, foreign_key: 'author_id', inverse_of: :author, dependent: :destroy

  has_many :active_subscriptions, class_name: 'Subscription', foreign_key: :follower_id, dependent: :destroy,
                                  inverse_of: :follower

  has_many :passive_subscriptions, class_name: 'Subscription', foreign_key: :followed_id, dependent: :destroy,
                                   inverse_of: :followed

  validates :first_name, :last_name, :username, presence: true, on: :create

  validates :first_name, presence: true, on: :update, if: :first_name_changed?

  validates :last_name, presence: true, on: :update, if: :last_name_changed?

  validates :username, presence: true, on: :update, if: :username_changed?
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'only allows letters, numbers, and underscores' },
                       length: { in: 3..20 },
                       if: :username_present?

  def follow(user)
    active_subscriptions.create(followed: user)
  end

  def unfollow(user)
    active_subscriptions.find_by(followed: user).destroy
  end

  def following?(user)
    active_subscriptions.exists?(followed: user)
  end

  private

  def username_present?
    username.present?
  end
end
