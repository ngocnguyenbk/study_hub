require 'rails_helper'

RSpec.describe Resolvers::JoinedGroupsResolver, type: :request do
  describe 'joinedGroups query' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it 'returns groups that the user has joined' do
      joined_groups = create_list(:group, 3)
      joined_groups.each { |group| group.accepted_members << user }

      create(:group)

      post '/graphql',
        params: { query: query(limit: 10) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinedGroups')

      expect(data.map { |g| g['id'] }).to match_array(joined_groups.map { |g| g.id.to_s })
    end

    it 'respects the limit argument' do
      groups = create_list(:group, 5)
      groups.each { |group| group.accepted_members << user }

      post '/graphql',
        params: { query: query(limit: 2) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinedGroups')

      expect(data.size).to eq(2)
    end

    it 'returns an empty array if the user has not joined any group' do
      post '/graphql',
        params: { query: query(limit: 5) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'joinedGroups')

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
        joinedGroups(limit: #{limit}) {
          id
          name
        }
      }
    GQL
  end
end
