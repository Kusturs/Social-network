# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, as: :author, inverse_of: :posts
  has_many :comments, dependent: :destroy

  validates :user, :content, presence: true, on: :create
  validates :user, presence: true, on: :update, if: :user_changed?
  validates :content, presence: true, on: :update, if: :content_changed?
  validates :content, length: { maximum: 140 }
end
