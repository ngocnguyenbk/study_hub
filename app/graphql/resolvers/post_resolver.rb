module Resolvers
  class PostResolver < BaseResolver
    description "Find a post by ID"

    argument :id, ID, required: true, description: "ID of the post"

    type Types::PostType, null: true

    def resolve(id:)
      authenticate_user!

      current_user.posts.find_by(id: id)
    end
  end
end
