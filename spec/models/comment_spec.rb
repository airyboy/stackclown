require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }
  it { should have_many :votes }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:commentable_id) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::COMMENT_BODY_MAX_LENGTH) }

  describe 'when comments are requested' do
    let!(:new_comment) { create(:comment_to_question, created_at: 1.hour.ago) }
    let!(:old_comment) { create(:comment_to_question, created_at: 1.day.ago) }

    it 'should be in the right order' do
      expect(Comment.all.to_a).to eq [old_comment, new_comment]
    end
  end

  describe 'Comment.upvote' do
    it_behaves_like 'voting up' do
      let!(:resource) { create(:comment_to_question) }
    end
  end

  describe 'Comment.downvote' do
    it_behaves_like 'voting down' do
      let!(:resource) { create(:comment_to_question) }
    end
  end


  describe '.question' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    context 'when belongs to a question' do
      it 'should return the correct parent question' do
        comment = create(:comment, commentable: question)
        expect(comment.question).to eq question
      end
    end

    context 'when belongs to and answer' do
      it 'should return the correct parent question' do
        comment = create(:comment, commentable: answer)
        expect(comment.question).to eq question
      end
    end
  end
end