# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :comments
  belongs_to :post, inverse_of: :comments, counter_cache: true
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', inverse_of: :parent

  before_create :set_post_from_parent

  validates :content, length: { minimum: 1, maximum: 100 }, presence: true
  validate :parent_comment_belongs_to_same_post

  scope :root_comments, -> { where(parent_id: nil) }

  def replies?
    replies.any?
  end

  def self.delete_with_replies(comment_id)
    sql = <<-SQL
      WITH RECURSIVE comment_tree AS (
        SELECT id, parent_id, 0 AS depth
        FROM comments
        WHERE id = :root_id
        UNION ALL
        SELECT c.id, c.parent_id, ct.depth + 1
        FROM comments c
        INNER JOIN comment_tree ct ON c.parent_id = ct.id
      )
      DELETE FROM comments
      WHERE id IN (
        SELECT id
        FROM comment_tree
        ORDER BY depth DESC
      );
    SQL

    connection.execute(sanitize_sql([sql, { root_id: comment_id }]))
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
