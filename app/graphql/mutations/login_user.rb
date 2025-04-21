# frozen_string_literal: true

module Mutations
  class LoginUser < BaseMutation
    description "Log in a user and return a JWT token"

    argument :email, String, required: true, description: "Email of the user"
    argument :password, String, required: true, description: "Password of the user"

    field :errors, [ String ], null: false, description: "List of errors if any"
    field :token, String, null: true, description: "JWT token for the user"
    field :user, Types::UserType, null: true, description: "The logged-in user object"

    def resolve(email:, password:)
      user = User.find_for_authentication(email: email)

      if user&.valid_password?(password)
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: [ I18n.t("devise.failure.invalid", authentication_keys: "email") ] }
      end
    end
  end
end
