# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"

  has_many :posts
  has_many :memberships
  has_many :groups, -> { where(memberships: { status: Membership.statuses[:accepted] }) }, through: :memberships
  has_many :pending_groups, -> { where(memberships: { status: Membership.statuses[:pending] }) }, through: :memberships, source: :group
  has_many :rejected_groups, -> { where(memberships: { status: Membership.statuses[:rejected] }) }, through: :memberships, source: :group
end
