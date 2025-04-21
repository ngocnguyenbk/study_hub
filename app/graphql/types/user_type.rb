# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description "User type"

    field :email, String, null: false, description: "Email of the user"
    field :id, ID, null: false, description: "ID of the user"
  end
end
