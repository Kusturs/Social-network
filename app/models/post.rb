# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :posts
  has_many :comments, dependent: :destroy, inverse_of: :post

  validates :author, :content, presence: true, on: :create
  validates :author, presence: true, on: :update, if: :author_changed?
  validates :content, presence: true, on: :update, if: :content_changed?
  validates :content, length: { maximum: 140 }
end
