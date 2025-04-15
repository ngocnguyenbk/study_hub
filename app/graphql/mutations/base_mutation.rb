# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class GraphQL::Schema::Argument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authenticate_user!
      user = context[:current_user]
      raise GraphQL::ExecutionError, I18n.t("graphql.errors.unauthenticated") unless user
      user
    end
  end
end
