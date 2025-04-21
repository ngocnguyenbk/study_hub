# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    description "Create a new post in a group"

    argument :content, String, required: true, description: "Content of the post"
    argument :group_id, ID, required: true, description: "ID of the group where the post will be created"
    argument :title, String, required: true, description: "Title of the post"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :post, Types::PostType, null: true, description: "The created post object"

    def resolve(group_id:, title:, content:)
      user = authenticate_user!
      group = user.groups.find_by(id: group_id)

      raise GraphQL::ExecutionError, I18n.t("graphql.errors.group_not_found") unless group

      post = Post.new(
        user: user,
        group: group,
        title: title,
        content: content
      )

      if post.save
        { post: post, errors: [] }
      else
        { post: nil, errors: post.errors.full_messages }
      end
    end
  end
end
