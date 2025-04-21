# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    description "Post type"

    field :content, String, null: false, description: "Content of the post"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Creation date of the post"
    field :group_id, Integer, null: false, description: "ID of the group"
    field :id, ID, null: false, description: "ID of the post"
    field :published_at, GraphQL::Types::ISO8601DateTime, null: true, description: "Publication date of the post"
    field :status, Types::PostStatusType, null: false, description: "Status of the post"
    field :title, String, null: false, description: "Title of the post"
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: "Last update date of the post"
    field :user_id, Integer, null: false, description: "ID of the user"
  end
end
