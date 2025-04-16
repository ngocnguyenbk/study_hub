class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: true

  validates :user_id, uniqueness: { scope: :group_id }

  enum :status, { pending: 0, accepted: 1, rejected: 2 }
end
