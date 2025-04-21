# frozen_string_literal: true

module Mutations
  class CreateGroup < BaseMutation
    description "Create a new group"

    argument :description, String, required: false, description: "Description of the group"
    argument :name, String, required: true, description: "Name of the group"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :group, Types::GroupType, null: true, description: "The created group object"

    def resolve(name:, description: nil)
      user = authenticate_user!
      group = Group.new(name: name, description: description, owner: user)

      if group.save
        { group: group, errors: [] }
      else
        { group: nil, errors: group.errors.full_messages }
      end
    end
  end
end
