# frozen_string_literal: true

module Types
  class GroupType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :owner_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :owner, Types::UserType, null: false
    field :max_members, Integer
    field :memberships_count, Integer, null: false
    field :status, Types::GroupStatusType, null: false
    field :pending_users, [ Types::UserType ], null: false
    field :accepted_users, [ Types::UserType ], null: false
    field :rejected_users, [ Types::UserType ], null: false
    field :memberships, [ Types::MembershipType ], null: false
  end
end
