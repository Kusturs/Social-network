require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_many(:posts).with_foreign_key('author_id').inverse_of(:author).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:active_subscriptions).class_name('Subscription').with_foreign_key(:follower_id).dependent(:destroy) }
    it { should have_many(:passive_subscriptions).class_name('Subscription').with_foreign_key(:followed_id).dependent(:destroy) }
  end

  describe 'validations' do
    context 'on create' do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:username) }
    end

    context 'on update' do
      let(:user) { create(:user) }

      it 'validates presence of first_name if changed' do
        user.first_name = ''
        expect(user).to be_invalid
      end

      it 'validates presence of last_name if changed' do
        user.last_name = ''
        expect(user).to be_invalid
      end

      it 'validates presence of username if changed' do
        user.username = ''
        expect(user).to be_invalid
      end
    end

    context 'username format' do
      it { should allow_value('user_123').for(:username) }
      it { should_not allow_value('user@123').for(:username) }
      it { should validate_length_of(:username).is_at_least(3).is_at_most(20) }
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe '#follow' do
      it 'creates a new subscription' do
        expect { user.follow(other_user) }.to change(Subscription, :count).by(1)
      end
    end

    describe '#unfollow' do
      before { user.follow(other_user) }

      it 'removes the subscription' do
        expect { user.unfollow(other_user) }.to change(Subscription, :count).by(-1)
      end
    end

    describe '#following?' do
      context 'when following' do
        before { user.follow(other_user) }

        it 'returns true' do
          expect(user.following?(other_user)).to be true
        end
      end

      context 'when not following' do
        it 'returns false' do
          expect(user.following?(other_user)).to be false
        end
      end
    end
  end
end
