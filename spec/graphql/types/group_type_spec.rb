require 'rails_helper'

RSpec.describe Types::GroupType, type: :request do
  describe 'GroupType' do
    let(:group) { create(:group) }

    it 'has fields' do
      expect(described_class.fields.keys).to include("acceptedMembers", "createdAt", "description", "id",
        "maxMembers", "memberships", "membershipsCount", "name", "owner", "ownerId", "pendingMembers",
        "rejectedMembers", "status", "updatedAt")
    end

    it 'returns the correct field values' do
      result = StudyHubSchema.execute("{ group(id: #{group.id}) { id name status owner { id } } }",
                                      context: { current_user: group.owner })
      data = result['data']['group']

      expect(data).to include(
        'id' => group.id.to_s,
        'name' => group.name,
        'status' => group.status.upcase,
        'owner' => { 'id' => group.owner.id.to_s }
      )
    end
  end
end
