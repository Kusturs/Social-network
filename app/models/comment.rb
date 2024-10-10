# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :comments
  belongs_to :post, inverse_of: :comments
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', inverse_of: :parent

  before_destroy :ensure_no_replies
  before_create :set_post_from_parent

  validates :content, length: { maximum: 1000 }
  validate :parent_comment_belongs_to_same_post

  scope :root_comments, -> { where(parent_id: nil) }

  def replies?
    replies.any?
  end

  private

  def set_post_from_parent
    self.post = parent.post if parent
  end

  def parent_comment_belongs_to_same_post
    return if parent_id.nil? || post_id == parent&.post_id

    errors.add(:parent, 'must belong to the same post')
  end

  def ensure_no_replies
    if replies.any?
      errors.add(:base, 'you cannot delete a comment that has replies')
      throw :abort
    end
  end
end
