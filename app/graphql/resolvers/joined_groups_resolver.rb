# frozen_string_literal: true

module Resolvers
  class JoinedGroupsResolver < BaseResolver
    description "Get list of groups that the user has joined"

    argument :limit, Integer, required: false, default_value: 10, description: "Limit the number of groups returned"

    type [ Types::GroupType ], null: false

    def resolve(limit:)
      authenticate_user!

      current_user.groups.limit(limit).preload(:memberships)
    end
  end
end
