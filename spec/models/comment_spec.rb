require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should belong_to(:commentable) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:commentable_id) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::COMMENT_BODY_MAX_LENGTH) }

  describe 'when comments are requested' do
    let!(:new_comment) { create(:comment, created_at: 1.hour.ago) }
    let!(:old_comment) { create(:comment, created_at: 1.day.ago) }

    it 'should be in the right order' do
      expect(Comment.all.to_a).to eq [old_comment, new_comment]
    end
  end
end