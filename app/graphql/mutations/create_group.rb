# frozen_string_literal: true

module Mutations
  class CreateGroup < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false

    field :group, Types::GroupType, null: true
    field :errors, [ String ], null: false

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
