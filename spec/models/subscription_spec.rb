require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:followed).class_name('User') }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      subscription = build(:subscription, follower: follower, followed: followed)
      expect(subscription).to be_valid
    end

    it 'is not valid when following self' do
      subscription = build(:subscription, follower: follower, followed: follower)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:base]).to include('Cannot follow yourself')
    end
  end

  describe 'counter cache' do
    it 'increments followed_count on follower' do
      expect do
        create(:subscription, follower: follower, followed: followed)
      end.to change { follower.reload.followed_count }.by(1)
    end

    it 'increments followers_count on followed' do
      expect do
        create(:subscription, follower: follower, followed: followed)
      end.to change { followed.reload.followers_count }.by(1)
    end

    it 'decrements followed_count on follower when destroyed' do
      subscription = create(:subscription, follower: follower, followed: followed)
      expect do
        subscription.destroy
      end.to change { follower.reload.followed_count }.by(-1)
    end

    it 'decrements followers_count on followed when destroyed' do
      subscription = create(:subscription, follower: follower, followed: followed)
      expect do
        subscription.destroy
      end.to change { followed.reload.followers_count }.by(-1)
    end
  end

  describe 'uniqueness' do
    it 'does not allow duplicate subscriptions' do
      create(:subscription, follower: follower, followed: followed)
      duplicate_subscription = build(:subscription, follower: follower, followed: followed)
      expect(duplicate_subscription).not_to be_valid
      expect(duplicate_subscription.errors[:follower_id]).to include('already follows this user')
    end

    it 'allows different users to follow the same user' do
      create(:subscription, follower: follower, followed: followed)
      another_follower = create(:user)
      another_subscription = build(:subscription, follower: another_follower, followed: followed)
      expect(another_subscription).to be_valid
    end
  end
end
