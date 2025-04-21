require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:group) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }

    context 'when status is published' do
      subject(:post) { build(:post, status: :published) }

      it 'validates presence of published_at' do
        post.published_at = nil
        post.valid?
        expect(post.errors[:published_at]).to include("can't be blank")
      end
    end

    context 'when status is draft' do
      subject(:post) { build(:post, status: :draft, published_at: nil) }

      it 'does not require published_at' do
        expect(post).to be_valid
      end
    end
  end

  describe 'Enums' do
    subject(:post) { build(:post) }

    it {
      expect(post).to define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2)
    }
  end
end
