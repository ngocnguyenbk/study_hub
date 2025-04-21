# frozen_string_literal: true

module Mutations
  class UpdatePost < BaseMutation
    description "Update an existing post"

    argument :content, String, required: false, description: "Content of the post"
    argument :id, ID, required: true, description: "ID of the post to update"
    argument :status, String, required: false, description: "Status of the post (e.g., draft, published)"
    argument :title, String, required: false, description: "Title of the post"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :post, Types::PostType, null: true, description: "The updated post object"

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
