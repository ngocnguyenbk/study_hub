class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :title, presence: true
  validates :content, presence: true

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  validates :published_at, presence: true, if: :published?
end
