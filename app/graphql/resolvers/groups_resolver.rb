module Resolvers
  class GroupsResolver < BaseResolver
    type [ Types::GroupType ], null: false
    description "Get list of groups"

    argument :limit, Integer, required: false, default_value: 10

    def resolve(limit:)
      authenticate_user!

      current_user.owned_groups.limit(limit).preload(:members)
    end
  end
end
