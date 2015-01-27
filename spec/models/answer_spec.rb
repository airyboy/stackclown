require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should have_many(:attachments) }
  it { should have_many(:comments) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should respond_to :best }

  it { should ensure_length_of(:body).is_at_most(GlobalConstants::ANSWER_BODY_MAX_LENGTH) }

  describe 'when they are requested' do
    let!(:old_answer) { FactoryGirl.create(:answer, body: 'Old answer', created_at: 1.month.ago)  }
    let!(:newer_answer) { FactoryGirl.create(:answer, body: 'New answer', created_at: 1.day.ago)  }

    it 'should be in the right order' do
      expect(Answer.all.to_a).to eq [old_answer, newer_answer]
    end
  end

  describe 'Answer.mark_best' do
    before(:each) do
      @question = create(:question)
      @answer1 = create(:answer, question: @question)
      @answer2 = create(:answer, question: @question)
    end

    it 'should mark an answer as best' do
      @answer1.mark_best
      expect(@answer1.best).to eq true
    end

    it 'should be the only best answer of a question' do
      expect(@answer1.question).to eq @answer2.question
      expect(@answer1.id).not_to eq @answer2.id
      @answer1.mark_best
      @answer1.reload
      @answer2.mark_best
      @answer2.reload
      expect(@answer2.best).to eq true
      expect(@answer1.best).to eq false
    end

    it 'should be initialized with not-best value' do
      expect(@answer1.best).to eq false
      expect(@answer2.best).to eq false
    end
  end

end
