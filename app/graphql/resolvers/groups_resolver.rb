module Resolvers
  class GroupsResolver < BaseResolver
    description "Get list of groups"

    argument :limit, Integer, required: false, default_value: 10, description: "Limit the number of groups returned"

    type [ Types::GroupType ], null: false

    def resolve(limit:)
      authenticate_user!

      current_user.owned_groups.limit(limit).preload(:memberships)
    end
  end
end
