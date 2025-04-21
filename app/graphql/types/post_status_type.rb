# frozen_string_literal: true

module Types
  class PostStatusType < Types::BaseObject
    description "Post status enum"

    value "DRAFT", "The post is a draft", value: "draft"
    value "PUBLISHED", "The post is published", value: "published"
    value "ARCHIVED", "The post is archived", value: "archived"
  end
end
