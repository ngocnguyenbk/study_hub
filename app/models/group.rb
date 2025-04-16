class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  Membership.statuses.each do |status, value|
    has_many :"#{status}_users",
             -> { where(memberships: { status: value }) },
             through: :memberships,
             source: :user
  end

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
