require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group).counter_cache(true) }
  end

  describe 'Validations' do
    subject(:membership) { build(:membership) }

    it {
      expect(membership).to validate_uniqueness_of(:user_id).scoped_to(:group_id)
    }
  end

  describe 'Enums' do
    subject(:membership) { build(:membership) }

    it {
      expect(membership).to define_enum_for(:status).with_values(pending: 0, accepted: 1, rejected: 2)
    }
  end
end
