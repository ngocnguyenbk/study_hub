require 'rails_helper'

RSpec.describe Resolvers::GroupResolver, type: :request do
  describe 'group query' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it 'returns a group by id' do
      group = create(:group, name: 'Rails Devs', owner: user)

      post '/graphql',
        params: { query: query(id: group.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'group')

      expect(data).to include(
        'id'   => group.id.to_s,
        'name' => 'Rails Devs'
      )
    end

    it 'returns nil for a non-existent group' do
      post '/graphql',
        params: { query: query(id: -1) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'group')

      expect(data).to be_nil
    end

    it 'raises an error if user is not authenticated' do
      post '/graphql',
        params: { query: query(id: 1) }

      json = JSON.parse(response.body)

      expect(json['errors'].first['message']).to eq('Unauthenticated')
    end
  end

  def query(id:)
    <<~GQL
      query {
        group(id: #{id}) {
          id
          name
        }
      }
    GQL
  end
end
