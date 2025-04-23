require 'rails_helper'

RSpec.describe Mutations::LoginUser, type: :request do
  describe 'loginUser' do
    let(:user) { create(:user, email: 'test@example.com', password: 'secure_pass') }

    it 'logs in a user with valid credentials' do
      post '/graphql',
        params: { query: mutation(email: user.email, password: 'secure_pass') }

      json = JSON.parse(response.body)
      data = json.dig('data', 'loginUser')

      expect(data['errors']).to be_empty
      expect(data['token']).to be_present
      expect(data['user']).to include(
        'id' => user.id.to_s,
        'email' => user.email
      )
    end

    it 'fails with invalid password' do
      post '/graphql',
        params: { query: mutation(email: user.email, password: 'wrong_pass') }

      json = JSON.parse(response.body)
      data = json.dig('data', 'loginUser')

      expect(data['token']).to be_nil
      expect(data['user']).to be_nil
      expect(data['errors']).to include('Invalid email or password.')
    end

    it 'fails with non-existent email' do
      post '/graphql',
        params: { query: mutation(email: 'noone@example.com', password: 'whatever') }

      json = JSON.parse(response.body)
      data = json.dig('data', 'loginUser')

      expect(data['token']).to be_nil
      expect(data['user']).to be_nil
      expect(data['errors']).to include('Invalid email or password.')
    end
  end

  def mutation(email:, password:)
    <<~GQL
      mutation {
        loginUser(input: { email: "#{email}", password: "#{password}" }) {
          token
          errors
          user {
            id
            email
          }
        }
      }
    GQL
  end
end
