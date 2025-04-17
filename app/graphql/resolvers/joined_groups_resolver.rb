# frozen_string_literal: true

module Resolvers
  class JoinedGroupsResolver < BaseResolver
    type [ Types::GroupType ], null: false
    description "Get list of groups that the user has joined"
    argument :limit, Integer, required: false, default_value: 10

    def resolve(limit:)
      authenticate_user!

      current_user.groups.limit(limit).preload(:memberships)
    end
  end
end
