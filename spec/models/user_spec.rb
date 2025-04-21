require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Devise modules' do
    it 'includes Devise modules' do
      expect(described_class.devise_modules).to include(
        :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable,
        :jwt_authenticatable
      )
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:owned_groups).class_name('Group').with_foreign_key('owner_id') }
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:groups).through(:memberships) }
    it { is_expected.to have_many(:pending_groups).through(:memberships).source(:group) }
    it { is_expected.to have_many(:rejected_groups).through(:memberships).source(:group) }
  end
end
