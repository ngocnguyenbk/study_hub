# frozen_string_literal: true

module Mutations
  class UpdatePost < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :content, String, required: false
    argument :status, String, required: false

    field :post, Types::PostType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **args)
      user = authenticate_user!
      post = user.posts.find_by(id: id)

      raise GraphQL::ExecutionError, I18n.t("graphql.errors.post_not_found") unless post

      attributes = args.slice(:title, :content, :status).compact

      if post.update(attributes)
        post.update(published_at: Time.current) if post.published? && post.published_at.nil?

        { post: post, errors: [] }
      else
        { post: nil, errors: post.errors.full_messages }
      end
    end
  end
end
