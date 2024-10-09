require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:author).class_name('User').inverse_of(:posts) }
    it { should have_many(:comments).dependent(:destroy).inverse_of(:post) }
  end

  describe 'validations' do
    it { should validate_presence_of(:author).on(:create) }
    it { should validate_presence_of(:content).on(:create) }
    it { should validate_length_of(:content).is_at_most(140) }

    context 'on update' do
      subject { create(:post) }

      it 'validates presence of author if changed' do
        subject.author = nil
        subject.valid?(:update)
        expect(subject.errors[:author]).to include("can't be blank")
      end

      it 'does not validate presence of author if not changed' do
        subject.content = 'New content'
        subject.valid?(:update)
        expect(subject.errors[:author]).to be_empty
      end

      it 'validates presence of content if changed' do
        subject.content = ''
        subject.valid?(:update)
        expect(subject.errors[:content]).to include("can't be blank")
      end

      it 'does not validate presence of content if not changed' do
        subject.author = create(:user)
        subject.valid?(:update)
        expect(subject.errors[:content]).to be_empty
      end
    end
  end

  describe 'creation' do
    let(:user) { create(:user) }
    let(:valid_attributes) { { author: user, content: 'Valid content' } }

    it 'is valid with valid attributes' do
      post = Post.new(valid_attributes)
      expect(post).to be_valid
    end

    it 'is not valid without an author' do
      post = Post.new(valid_attributes.merge(author: nil))
      expect(post).to_not be_valid
    end

    it 'is not valid without content' do
      post = Post.new(valid_attributes.merge(content: nil))
      expect(post).to_not be_valid
    end

    it 'is not valid with content longer than 140 characters' do
      post = Post.new(valid_attributes.merge(content: 'a' * 141))
      expect(post).to_not be_valid
    end
  end
end
