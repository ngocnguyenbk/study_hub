require 'rails_helper'

RSpec.describe Mutations::UpdateGroup, type: :request do
  describe 'updateGroup mutation' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }
    let(:group) { create(:group, owner: user) }
    let(:params) do
      {
        id: group.id,
        name: 'Updated Group Name',
        description: 'Updated group description',
        max_members: 100,
        status: 'active'
      }
    end

    it 'updates a group successfully with valid data' do
      post '/graphql',
        params: { query: mutation(**params) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'updateGroup')

      expect(data['errors']).to be_empty
      expect(data['group']).to include(
        'name' => params[:name], 'description' => params[:description],
        'maxMembers' => params[:max_members], 'status' => params[:status].upcase
      )
    end

    it 'fails when the group does not exist' do
      post '/graphql',
        params: { query: mutation(**params.merge(id: -1)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Group not found')
    end

    it 'fails when the user is not the owner of the group' do
      another_user = create(:user)
      another_group = create(:group, owner: another_user)

      post '/graphql',
        params: { query: mutation(**params.merge(id: another_group.id)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Group not found')
    end

    it 'fails when attempting to update with invalid data' do
      invalid_name = ''

      post '/graphql',
        params: { query: mutation(**params.merge(name: invalid_name)) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'updateGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include("Name can't be blank")
    end

    it 'returns unauthenticated error when not logged in' do
      post '/graphql',
        params: { query: mutation(**params) }

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Unauthenticated')
    end
  end

  def mutation(id:, name: nil, description: nil, max_members: nil, status: nil)
    <<~GQL
      mutation {
        updateGroup(input: {
          id: "#{id}",
          name: "#{name}",
          description: "#{description}",
          maxMembers: #{max_members},
          status: "#{status}"
        }) {
          group {
            id
            name
            description
            maxMembers
            status
          }
          errors
        }
      }
    GQL
  end
end
