# frozen_string_literal: true

module Mutations
  class JoinGroup < BaseMutation
    description "Join a group"

    argument :group_id, ID, required: true, description: "ID of the group to join"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :group, Types::GroupType, null: true, description: "The group object"

    def resolve(group_id:)
      user = authenticate_user!
      group = Group.find_by(id: group_id)

      return error_response(:group_not_found) if group.nil?
      return error_response(:group_yourself) if group.owner == user
      return error_response(:group_already_requested) if group.pending_users.include?(user)
      return error_response(:group_already_joined) if group.accepted_users.include?(user)
      return error_response(:group_already_rejected) if group.rejected_users.include?(user)

      user.groups << group

      {
        group: group,
        errors: []
      }
    rescue ActiveRecord::RecordInvalid => e
      { group: nil, errors: [ e.message ] }
    end

    private

    def error_response(error_key)
      { group: nil, errors: [ I18n.t("graphql.errors.#{error_key}") ] }
    end
  end
end
