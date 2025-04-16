# frozen_string_literal: true

module Mutations
  class UpdateGroup < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :status, String, required: false
    argument :max_members, Integer, required: false

    field :success, Boolean, null: false
    field :errors, [ String ], null: false
    field :group, Types::GroupType, null: true

    def resolve(id:, **args)
      user = authenticate_user!
      group = user.owned_groups.find_by(id: id)

      raise GraphQL::ExecutionError, I18n.t("graphql.errors.group_not_found") unless group

      attributes = args.slice(:name, :description, :status, :max_members).compact

      if group.update(attributes)
        { group: group, errors: [] }
      else
        { group: nil, errors: group.errors.full_messages }
      end
    end
  end
end
