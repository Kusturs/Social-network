require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { build(:comment, author: user, post: post) }

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('User').inverse_of(:comments) }
    it { is_expected.to belong_to(:post).inverse_of(:comments) }
    it { is_expected.to belong_to(:parent).class_name('Comment').optional }
    it { is_expected.to have_many(:replies).class_name('Comment').with_foreign_key('parent_id').inverse_of(:parent) }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:content).is_at_most(100) }

    context 'when parent comment belongs to the same post' do
      it 'is valid when parent comment belongs to the same post' do
        parent_comment = create(:comment, post: post)
        reply = build(:reply, parent_comment: parent_comment, post: post)
        expect(reply).to be_valid
      end

      it 'is invalid when parent comment belongs to a different post' do
        different_post = create(:post)
        parent_comment = create(:comment, post: different_post)
        reply = build(:reply, parent_comment: parent_comment, post: post)
        expect(reply).to be_invalid
        expect(reply.errors[:parent]).to include('must belong to the same post')
      end
    end
  end

  describe 'scopes' do
    describe '.root_comments' do
      it 'returns only root comments' do
        root_comment = create(:comment, post: post)
        child_comment = create(:reply, parent_comment: root_comment)
        expect(described_class.root_comments).to include(root_comment)
        expect(described_class.root_comments).not_to include(child_comment)
      end
    end
  end

  describe 'callbacks' do
    describe 'before_create' do
      it 'sets the post from the parent comment' do
        parent_comment = create(:comment)
        child_comment = build(:reply, parent_comment: parent_comment, post: nil)
        child_comment.save
        expect(child_comment.post).to eq(parent_comment.post)
      end
    end
  end

  describe '#replies?' do
    it 'returns true if the comment has replies' do
      parent = create(:comment)
      create(:reply, parent_comment: parent)
      expect(parent.replies?).to be true
    end

    it 'returns false if the comment has no replies' do
      comment = create(:comment)
      expect(comment.replies?).to be false
    end
  end

  describe '.delete_with_replies' do
    it 'deletes the comment and all its replies' do
      root = create(:comment)
      child1 = create(:reply, parent_comment: root)
      child2 = create(:reply, parent_comment: root)
      grandchild = create(:reply, parent_comment: child1)

      expect do
        described_class.delete_with_replies(root.id)
      end.to change(described_class, :count).by(-4)

      expect(described_class.exists?(root.id)).to be false
      expect(described_class.exists?(child1.id)).to be false
      expect(described_class.exists?(child2.id)).to be false
      expect(described_class.exists?(grandchild.id)).to be false
    end

    it 'does not delete unrelated comments' do
      root = create(:comment)
      create(:reply, parent_comment: root)
      unrelated = create(:comment)

      expect do
        described_class.delete_with_replies(root.id)
      end.to change(described_class, :count).by(-2)

      expect(described_class.exists?(unrelated.id)).to be true
    end
  end
end
