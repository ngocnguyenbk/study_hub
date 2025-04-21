# frozen_string_literal: true

module Mutations
  class UpdateGroup < BaseMutation
    description "Update an existing group"

    argument :description, String, required: false, description: "Description of the group"
    argument :id, ID, required: true, description: "ID of the group to update"
    argument :max_members, Integer, required: false, description: "Maximum number of members in the group"
    argument :name, String, required: false, description: "Name of the group"
    argument :status, String, required: false, description: "Status of the group (e.g., public, private)"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :group, Types::GroupType, null: true, description: "The updated group object"
    field :success, Boolean, null: false, description: "Indicates if the update was successful"

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
