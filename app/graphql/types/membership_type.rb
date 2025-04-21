# frozen_string_literal: true

module Types
  class MembershipType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :group_id, Integer, null: false
    field :status, Types::MembershipStatusType, null: false
    field :reason, String
    field :joined_at, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
