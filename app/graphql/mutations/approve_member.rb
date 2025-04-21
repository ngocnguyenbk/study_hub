# frozen_string_literal: true

module Mutations
  class ApproveMember < BaseMutation
    description "Approve a pending member to join a group"

    argument :group_id, ID, required: true, description: "ID of the group"
    argument :user_id, ID, required: true, description: "ID of the user to approve"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :membership, Types::MembershipType, null: true, description: "The approved membership object"

    def resolve(group_id:, user_id:)
      user = authenticate_user!

      group = user.owned_groups.find_by(id: group_id)
      raise GraphQL::ExecutionError, I18n.t("graphql.errors.group_not_found") unless group

      membership = group.memberships.find_by(user_id: user_id)
      raise GraphQL::ExecutionError, I18n.t("graphql.errors.membership_not_found") unless membership

      if membership.update(status: Membership.statuses[:accepted])
        {
          membership: membership,
          errors: []
        }
      else
        {
          membership: nil,
          errors: membership.errors.full_messages
        }
      end
    end
  end
end
