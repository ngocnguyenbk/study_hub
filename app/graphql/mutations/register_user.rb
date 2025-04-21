# frozen_string_literal: true

module Mutations
  class RegisterUser < BaseMutation
    description "Register a new user"

    argument :email, String, required: true, description: "Email of the user"
    argument :password, String, required: true, description: "Password of the user"
    argument :password_confirmation, String, required: true, description: "Password confirmation of the user"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :user, Types::UserType, null: true, description: "The registered user object"

    def resolve(email:, password:, password_confirmation:)
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
