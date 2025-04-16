# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id"
  has_many :memberships
  has_many :groups, through: :memberships
end
