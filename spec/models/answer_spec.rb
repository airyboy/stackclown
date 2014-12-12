require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should have_many(:comments) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should ensure_length_of(:body).is_at_most(GlobalConstants::ANSWER_BODY_MAX_LENGTH) }

  describe 'when they are requested' do
    let!(:old_answer) { FactoryGirl.create(:answer, body: 'Old answer', created_at: 1.month.ago)  }
    let!(:newer_answer) { FactoryGirl.create(:answer, body: 'New answer', created_at: 1.day.ago)  }

    it 'should be in the right order' do
      expect(Answer.all.to_a).to eq [old_answer, newer_answer]
    end
  end

end
