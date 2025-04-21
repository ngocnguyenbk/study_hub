# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: true
    def me
      context[:current_user]
    end

    field :group, resolver: Resolvers::GroupResolver
    field :owned_groups, resolver: Resolvers::GroupsResolver
    field :joined_groups, resolver: Resolvers::JoinedGroupsResolver
  end
end
