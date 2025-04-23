require 'rails_helper'

RSpec.describe Mutations::RegisterUser, type: :request do
  describe 'registerUser' do
    let(:email) { 'newuser@example.com' }
    let(:password) { 'strong_password' }
    let(:existing_user) { create(:user, email: 'taken@example.com') }

    it 'registers a new user with valid data' do
      post '/graphql',
        params: { query: mutation(email: email, password: password, password_confirmation: password) }

      json = JSON.parse(response.body)
      data = json.dig('data', 'registerUser')

      expect(data['errors']).to be_empty
      expect(data['user']).to include(
        'email' => email
      )
    end

    it 'fails when password and confirmation do not match' do
      post '/graphql',
        params: { query: mutation(email: 'mismatch@example.com', password: 'abc123', password_confirmation: 'xyz789') }

      json = JSON.parse(response.body)
      data = json.dig('data', 'registerUser')

      expect(data['user']).to be_nil
      expect(data['errors']).to include("Password confirmation doesn't match Password")
    end

    it 'fails when email is already taken' do
      post '/graphql',
        params: { query: mutation(email: existing_user.email, password: '123456', password_confirmation: '123456') }

      json = JSON.parse(response.body)
      data = json.dig('data', 'registerUser')

      expect(data['user']).to be_nil
      expect(data['errors']).to include("Email has already been taken")
    end
  end

  def mutation(email:, password:, password_confirmation:)
    <<~GQL
      mutation {
        registerUser(input: {
          email: "#{email}",
          password: "#{password}",
          passwordConfirmation: "#{password_confirmation}"
        }) {
          user {
            id
            email
          }
          errors
        }
      }
    GQL
  end
end
