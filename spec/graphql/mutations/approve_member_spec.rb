require 'rails_helper'

RSpec.describe Mutations::ApproveMember, type: :request do
  describe 'approveMember mutation' do
    let(:owner) { create(:user) }
    let(:member) { create(:user) }
    let(:group) { create(:group, owner: owner) }
    let!(:membership) { create(:membership, group: group, user: member, status: :pending) }
    let(:headers) { auth_headers_for(owner) }

    it 'approves a pending membership' do
      post '/graphql',
        params: { query: mutation(group_id: group.id, user_id: member.id) },
        headers: headers

      json = JSON.parse(response.body)
      data = json.dig('data', 'approveMember')

      expect(data['errors']).to be_empty
      expect(data['membership']).to include(
        'id' => membership.id.to_s,
        'status' => 'ACCEPTED'
      )
    end

    it 'returns error if group is not found' do
      post '/graphql',
        params: { query: mutation(group_id: -1, user_id: member.id) },
        headers: headers

      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq('Group not found')
    end

    it 'returns error if membership is not found' do
      membership.destroy

      post '/graphql',
        params: { query: mutation(group_id: group.id, user_id: member.id) },
        headers: headers

      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq('Membership not found')
    end

    it 'returns unauthenticated if not logged in' do
      post '/graphql',
        params: { query: mutation(group_id: group.id, user_id: member.id) }

      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq('Unauthenticated')
    end
  end

  def mutation(group_id:, user_id:)
    <<~GQL
      mutation {
        approveMember(input: {
          groupId: "#{group_id}",
          userId: "#{user_id}"
        }) {
          membership {
            id
            status
          }
          errors
        }
      }
    GQL
  end
end
