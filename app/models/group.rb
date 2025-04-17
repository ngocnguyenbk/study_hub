class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :pending_members, -> { where(memberships: { status: Membership.statuses[:pending] }) }, through: :memberships, source: :user
  has_many :accepted_members, -> { where(memberships: { status: Membership.statuses[:accepted] }) }, through: :memberships, source: :user
  has_many :rejected_members, -> { where(memberships: { status: Membership.statuses[:rejected] }) }, through: :memberships, source: :user

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  enum :status, { active: 0, inactive: 1 }
end
