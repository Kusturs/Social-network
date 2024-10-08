class User < ApplicationRecord
  validates :first_name, :last_name, :username, presence: true, on: :create

  validates :first_name, presence: true, on: :update, if: :first_name_changed?

  validates :last_name, presence: true, on: :update, if: :last_name_changed?

  validates :username, presence: true, on: :update, if: :username_changed?
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: 'only allows letters, numbers, and underscores' },
                       length: { in: 3..20 },
                       if: :username_present?

  private

  def username_present?
    username.present?
  end
end
