# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    argument :group_id, ID, required: true
    argument :title, String, required: true
    argument :content, String, required: true

    field :post, Types::PostType, null: true
    field :errors, [ String ], null: false

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
