require 'rails_helper'

RSpec.describe Mutations::JoinGroup, type: :request do
  describe 'joinGroup mutation' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }
    let(:group) { create(:group, owner: create(:user)) }

    it 'allows a user to join a group if conditions are met' do
      post '/graphql',
        params: { query: mutation(group_id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['errors']).to be_empty
      expect(data['group']['id']).to eq(group.id.to_s)
    end

    it 'fails when the group does not exist' do
      post '/graphql',
        params: { query: mutation(group_id: -1) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include('Group not found')
    end

    it 'fails when trying to join your own group' do
      group.update(owner: user)

      post '/graphql',
        params: { query: mutation(group_id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include('You cannot join your own group')
    end

    it 'fails if the user has already requested to join' do
      group.pending_members << user

      post '/graphql',
        params: { query: mutation(group_id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include('You have already requested to join this group')
    end

    it 'fails if the user has already joined the group' do
      group.accepted_members << user

      post '/graphql',
        params: { query: mutation(group_id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include('You have already joined this group')
    end

    it 'fails if the user has been rejected from the group' do
      group.rejected_members << user

      post '/graphql',
        params: { query: mutation(group_id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinGroup')

      expect(data['group']).to be_nil
      expect(data['errors']).to include('You have been rejected from this group')
    end

    it 'returns unauthenticated error when not logged in' do
      post '/graphql',
        params: { query: mutation(group_id: group.id) }

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Unauthenticated')
    end
  end

  def mutation(group_id:)
    <<~GQL
      mutation {
        joinGroup(input: {
          groupId: "#{group_id}"
        }) {
          group {
            id
            name
          }
          errors
        }
      }
    GQL
  end
end
