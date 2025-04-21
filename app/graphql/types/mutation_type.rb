# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description "Mutation root"

    field :approve_member, mutation: Mutations::ApproveMember, description: "Approve a member's request to join a group"
    field :create_group, mutation: Mutations::CreateGroup, description: "Create a new group"
    field :create_post, mutation: Mutations::CreatePost, description: "Create a new post in a group"
    field :join_group, mutation: Mutations::JoinGroup, description: "Join a group"
    field :login_user, mutation: Mutations::LoginUser, description: "Login a user"
    field :register_user, mutation: Mutations::RegisterUser, description: "Register a new user"
    field :update_group, mutation: Mutations::UpdateGroup, description: "Update an existing group"
    field :update_post, mutation: Mutations::UpdatePost, description: "Update an existing post in a group"
  end
end
