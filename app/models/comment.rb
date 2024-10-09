# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :comments
  belongs_to :post, dependent: :destroy, inverse_of: :comments
  belongs_to :parent, class_name: 'Comment', optional: true, dependent: :nullify
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', inverse_of: :parent

  validates :content, length: { maximum: 1000 }
  validate :parent_comment_belongs_to_same_post

  scope :root_comments, -> { where(parent_id: nil) }

  def root?
    parent_id.nil?
  end

  def reply?
    parent_id.present?
  end

  private

  def set_post_from_parent
    self.post = parent.post if parent
  end

  def parent_comment_belongs_to_same_post
    return if parent_id.nil? || post_id == parent&.post_id

    errors.add(:parent, 'must belong to the same post')
  end
end
