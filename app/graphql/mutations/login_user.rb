# frozen_string_literal: true

module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [ String ], null: false

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
