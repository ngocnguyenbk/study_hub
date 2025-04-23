require 'rails_helper'

RSpec.describe Resolvers::GroupsResolver, type: :request do
  describe 'groups query' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it 'returns a list of groups the user owns' do
      owned_groups = create_list(:group, 3, owner: user)
      create(:group)

      post '/graphql',
        params: { query: query(limit: 5) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'ownedGroups')
      expect(data.map { |g| g['id'] }).to match_array(owned_groups.map { |g| g.id.to_s })
    end

    it 'respects the limit argument' do
      create_list(:group, 5, owner: user)

      post '/graphql',
        params: { query: query(limit: 2) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'ownedGroups')

      expect(data.size).to eq(2)
    end

    it 'returns an empty array if user has no groups' do
      post '/graphql',
        params: { query: query(limit: 5) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'ownedGroups')

      expect(data).to eq([])
    end

    it 'raises an error if user is not authenticated' do
      post '/graphql',
        params: { query: query(limit: 5) }

      json = JSON.parse(response.body)

      expect(json['errors']).to include(
        a_hash_including('message' => 'Unauthenticated')
      )
    end
  end

  def query(limit:)
    <<~GQL
      query {
        ownedGroups(limit: #{limit}) {
          id
          name
        }
      }
    GQL
  end
end
