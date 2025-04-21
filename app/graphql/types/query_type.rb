# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "Query root"

    field :group, resolver: Resolvers::GroupResolver, description: "Get a group by ID"
    field :joined_groups, resolver: Resolvers::JoinedGroupsResolver, description: "Get groups joined by the current user"
    field :me, Types::UserType, null: true, description: "Get the current user"
    field :owned_groups, resolver: Resolvers::GroupsResolver, description: "Get groups owned by the current user"
    field :post, resolver: Resolvers::PostResolver, description: "Get a post by ID"

    def me
      context[:current_user]
    end
  end
end
