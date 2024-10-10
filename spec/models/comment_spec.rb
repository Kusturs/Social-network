# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:parent_comment) { create(:comment, post: post) }

  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it { should belong_to(:post) }
    it { should belong_to(:parent).class_name('Comment').optional }
    it { should have_many(:replies).class_name('Comment') }
  end

  describe 'validations' do
    it { should validate_length_of(:content).is_at_most(1000) }

    context 'parent comment belongs to same post' do
      let(:comment) { build(:comment, post: post, parent: parent_comment) }

      it 'is valid' do
        expect(comment).to be_valid
      end
    end

    context 'parent comment belongs to different post' do
      let(:other_post) { create(:post) }
      let(:comment) { build(:comment, post: post, parent: create(:comment, post: other_post)) }

      it 'is invalid' do
        expect(comment).to be_invalid
        expect(comment.errors[:parent]).to include('must belong to the same post')
      end
    end
  end

  describe 'scopes' do
    describe '.root_comments' do
      let!(:root_comment) { create(:comment, post: post) }
      let!(:reply) { create(:comment, post: post, parent: root_comment) }

      it 'returns only root comments' do
        expect(Comment.root_comments).to include(root_comment)
        expect(Comment.root_comments).not_to include(reply)
      end
    end
  end

  describe '#replies?' do
    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }

    context 'when comment has replies' do
      before { create(:comment, parent: comment, post: post) }

      it 'returns true' do
        expect(comment.replies?).to be true
      end
    end

    context 'when comment has no replies' do
      it 'returns false' do
        expect(comment.replies?).to be false
      end
    end
  end

  describe 'before_destroy callback' do
    let(:post) { create(:post) }
    let(:comment) { create(:comment, post: post) }
  
    context 'when comment has no replies' do
      it 'allows destruction' do
        comment.destroy!
        expect(comment.destroyed?).to be true
      end
    end
  end
end
