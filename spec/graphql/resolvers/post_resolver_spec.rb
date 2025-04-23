require 'rails_helper'

RSpec.describe Resolvers::PostResolver, type: :request do
  describe 'post query' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }

    it 'returns a post by id' do
      post_record = create(:post, title: 'Hello GraphQL', user: user)

      post '/graphql',
        params: { query: query(id: post_record.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'post')

      expect(data).to include(
        'id'    => post_record.id.to_s,
        'title' => 'Hello GraphQL'
      )
    end

    it 'returns nil for a non-existent post' do
      post '/graphql',
        params: { query: query(id: -1) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'post')

      expect(data).to be_nil
    end

    it 'returns nil if the post does not belong to the user' do
      other_post = create(:post)

      post '/graphql',
        params: { query: query(id: other_post.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'post')

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
        post(id: #{id}) {
          id
          title
          content
        }
      }
    GQL
  end
end
