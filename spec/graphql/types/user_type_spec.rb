require 'rails_helper'

RSpec.describe Types::UserType, type: :request do
  describe 'UserType' do
    let(:user) { create(:user) }

    it 'has fields' do
      expect(described_class.fields.keys).to include('id', 'email')
    end

    it 'returns the correct field values' do
      result = StudyHubSchema.execute("{ me { id email } }", context: { current_user: user })
      data = result['data']['me']

      expect(data).to include('id' => user.id.to_s, 'email' => user.email)
    end
  end
end
