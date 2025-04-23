require 'rails_helper'

RSpec.describe Mutations::UpdatePost, type: :request do
  describe 'updatePost mutation' do
    let(:user) { create(:user) }
    let(:headers) { auth_headers_for(user) }
    let(:group) { create(:group) }
    let(:post_record) { create(:post, user: user, group: group) }

    let(:params) do
      {
        id: post_record.id,
        title: 'Updated Post Title',
        content: 'Updated content of the post.',
        status: 'published'
      }
    end

    it 'updates a post successfully with valid data' do
      post '/graphql',
        params: { query: mutation(**params) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'updatePost')

      expect(data['errors']).to be_empty
      expect(data['post']).to include(
        'title' => params[:title], 'content' => params[:content], 'status' => params[:status].upcase
      )
    end

    it 'fails when the post does not exist' do
      post '/graphql',
        params: { query: mutation(**params.merge(id: -1)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Post not found')
    end

    it 'fails when the user is not the owner of the post' do
      another_user = create(:user)
      another_post = create(:post, user: another_user, group: group)

      post '/graphql',
        params: { query: mutation(**params.merge(id: another_post.id)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Post not found')
    end

    it 'fails when title is blank' do
      post '/graphql',
        params: { query: mutation(**params.merge(title: '')) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'updatePost')

      expect(data['post']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
    end

    it 'fails when content is blank' do
      post '/graphql',
        params: { query: mutation(**params.merge(content: '')) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'updatePost')

      expect(data['post']).to be_nil
      expect(data['errors']).to include("Content can't be blank")
    end

    it 'returns unauthenticated error when not logged in' do
      post '/graphql',
        params: { query: mutation(**params) }

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Unauthenticated')
    end
  end

  def mutation(id:, title: nil, content: nil, status: nil)
    <<~GQL
      mutation {
        updatePost(input: {
          id: "#{id}",
          title: "#{title}",
          content: "#{content}",
          status: "#{status}"
        }) {
          post {
            id
            title
            content
            status
          }
          errors
        }
      }
    GQL
  end
end
