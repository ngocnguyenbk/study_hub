require 'rails_helper'

RSpec.describe Mutations::CreateGroup, type: :request do
  describe 'createGroup mutation' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it 'creates a group with valid data' do
      post '/graphql',
        params: { query: mutation(name: 'Dev Group', description: 'A place for devs') },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'createGroup')

      expect(data['errors']).to be_empty
      expect(data['group']).to include(
        'name' => 'Dev Group',
        'description' => 'A place for devs'
      )
    end

    it 'fails when name is missing' do
      post '/graphql',
        params: { query: mutation(name: '', description: 'No name') },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'createGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include("Name can't be blank")
    end

    it 'returns unauthenticated error when not logged in' do
      post '/graphql',
        params: { query: mutation(name: 'Dev Group', description: 'Should fail') }

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Unauthenticated')
    end
  end

  def mutation(name:, description:)
    <<~GQL
      mutation {
        createGroup(input: {
          name: "#{name}",
          description: "#{description}"
        }) {
          group {
            id
            name
            description
          }
          errors
        }
      }
    GQL
  end
end
