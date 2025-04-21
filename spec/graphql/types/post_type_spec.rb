require 'rails_helper'

RSpec.describe Types::PostType, type: :request do
  describe 'PostType' do
    let(:post) { create(:post) }

    it 'has fields' do
      expect(described_class.fields.keys).to include("id", "userId", "groupId", "title", "content",
        "status", "publishedAt", "createdAt", "updatedAt")
    end

    it 'returns the correct field values' do
      result = StudyHubSchema.execute("{ post(id: #{post.id}) { id userId groupId title content status publishedAt createdAt updatedAt } }",
                                      context: { current_user: post.user })
      data = result['data']['post']

      expect(data).to include(
        'id' => post.id.to_s, 'title' => post.title, 'content' => post.content, 'status' => post.status.upcase,
        'publishedAt' => post.published_at&.iso8601, 'createdAt' => post.created_at.iso8601,
        'updatedAt' => post.updated_at.iso8601, 'userId' => post.user_id, 'groupId' => post.group_id
      )
    end
  end
end
