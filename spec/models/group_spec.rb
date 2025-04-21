require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:members).through(:memberships).source(:user) }
    it { is_expected.to have_many(:pending_members).through(:memberships).source(:user) }
    it { is_expected.to have_many(:accepted_members).through(:memberships).source(:user) }
    it { is_expected.to have_many(:rejected_members).through(:memberships).source(:user) }
  end

  describe 'Validations' do
    subject(:group) { build(:group) }

    it { is_expected.to validate_presence_of(:name) }

    it {
      expect(group).to validate_uniqueness_of(:name).case_insensitive
    }
  end

  describe 'Enums' do
    subject(:group) { build(:group) }

    it {
      expect(group).to define_enum_for(:status).with_values(active: 0, inactive: 1)
    }
  end
end
