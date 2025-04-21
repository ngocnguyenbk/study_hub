# frozen_string_literal: true

module Types
  class MembershipType < Types::BaseObject
    description "A membership in a group"

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Creation date of the membership"
    field :group_id, Integer, null: false, description: "ID of the group"
    field :id, ID, null: false, description: "ID of the membership"
    field :joined_at, GraphQL::Types::ISO8601DateTime, null: true, description: "Date when the user joined the group"
    field :reason, String, null: true, description: "Reason for the membership status"
    field :status, Types::MembershipStatusType, null: false, description: "Status of the membership"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Last update date of the membership"
    field :user_id, Integer, null: false, description: "ID of the user"
  end
end
