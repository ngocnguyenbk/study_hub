# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :approve_member, mutation: Mutations::ApproveMember
    field :create_post, mutation: Mutations::CreatePost
    field :update_group, mutation: Mutations::UpdateGroup
    field :join_group, mutation: Mutations::JoinGroup
    field :create_group, mutation: Mutations::CreateGroup
    field :login_user, mutation: Mutations::LoginUser
    field :register_user, mutation: Mutations::RegisterUser
  end
end
