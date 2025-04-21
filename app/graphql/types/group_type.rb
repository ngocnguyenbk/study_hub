# frozen_string_literal: true

module Types
  class GroupType < Types::BaseObject
    description "A group of users"

    field :accepted_members, [ Types::UserType ], null: false, description: "List of accepted members"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Creation date of the group"
    field :description, String, null: true, description: "Description of the group"
    field :id, ID, null: false, description: "ID of the group"
    field :max_members, Integer, null: false, description: "Maximum number of members in the group"
    field :memberships, [ Types::MembershipType ], null: false, description: "List of memberships in the group"
    field :memberships_count, Integer, null: false, description: "Number of memberships in the group"
    field :name, String, null: false, description: "Name of the group"
    field :owner, Types::UserType, null: false, description: "Owner of the group"
    field :owner_id, Integer, null: false, description: "ID of the owner"
    field :pending_members, [ Types::UserType ], null: false, description: "List of pending members"
    field :rejected_members, [ Types::UserType ], null: false, description: "List of rejected members"
    field :status, Types::GroupStatusType, null: false, description: "Status of the group"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Last update date of the group"
  end
end
