module Resolvers
  class GroupResolver < BaseResolver
    type Types::GroupType, null: true
    description "Find a group by ID"

    argument :id, ID, required: true

    def resolve(id:)
      authenticate_user!

      Group.find_by(id: id)
    end
  end
end
