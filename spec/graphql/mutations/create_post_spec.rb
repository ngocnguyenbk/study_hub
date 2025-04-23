require 'rails_helper'

RSpec.describe Mutations::CreatePost, type: :request do
  describe 'createPost mutation' do
    let(:user) { create(:user) }
    let(:params) do
      {
        group_id: group.id,
        title: 'New Post Title',
        content: 'This is the content of the post.'
      }
    end
    let(:headers) { auth_headers_for(user) }
    let(:group) { create(:group) }

    before { user.groups << group }


    it 'creates a post successfully with valid data' do
      post '/graphql',
        params: { query: mutation(**params) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'createPost')

      expect(data['errors']).to be_empty
      expect(data['post']).to include(
        'title' => params[:title],
        'content' => params[:content]
      )
    end

    it 'fails when the group does not exist' do
      post '/graphql',
        params: { query: mutation(**params.merge(group_id: -1)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Group not found')
    end

    it 'fails when user does not belong to the group' do
      other_group = create(:group)

      post '/graphql',
        params: { query: mutation(**params.merge(group_id: other_group.id)) },
        headers: headers

      json = JSON.parse(response.body)
      errors = json['errors']

      expect(errors.first['message']).to eq('Group not found')
    end

    it 'fails when title is blank' do
      post '/graphql',
        params: { query: mutation(**params.merge(title: '')) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'createPost')

      expect(data['post']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
    end

    it 'fails when content is blank' do
      post '/graphql',
        params: { query: mutation(**params.merge(content: '')) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'createPost')

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

  def mutation(group_id:, title:, content:)
    <<~GQL
      mutation {
        createPost(input: {
          groupId: "#{group_id}",
          title: "#{title}",
          content: "#{content}"
        }) {
          post {
            id
            title
            content
          }
          errors
        }
      }
    GQL
  end
end
