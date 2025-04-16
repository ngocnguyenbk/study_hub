# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    def current_user
      context[:current_user] || raise(GraphQL::ExecutionError, I18n.t("graphql.errors.unauthenticated"))
    end

    def authenticate_user!
      current_user
    end
  end
end
