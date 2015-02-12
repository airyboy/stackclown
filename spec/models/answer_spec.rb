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

    it 'should be the only one best answer of a question' do
      @answer1.mark_best
      @answer2.mark_best
      expect(@answer2.reload).to be_best
      expect(@answer1.reload).not_to be_best
    end

    it 'should be initialized with not-best value' do
      expect(@answer1.best).to eq false
      expect(@answer2.best).to eq false
    end
  end

  describe '.send_notification' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { build(:answer, question: question) }
    let(:subscriptions) { create_list(:subscription, 2, question: question)}

    it 'should send notification to subscribers after creation except answer creator' do
      question.subscriptions.each do |subscription|
        if subscription.user != answer.user
          expect(UserMailer).to receive(:new_question_answer).with(subscription.user, question, answer).and_call_original
        end
      end

      answer.save!
    end

    it 'should not send notification to answer creator' do
      my_answer = build(:answer, question: question, user: user)
      allow(UserMailer).to receive(:new_question_answer).and_call_original
      expect(UserMailer).not_to receive(:new_question_answer).with(user, question, my_answer)
      my_answer.save!
    end

    it 'should not send notification to question author after update' do
      answer.save!
      answer.body = 'new body'
      question.subscriptions.each do |subscription|
        expect(UserMailer).not_to receive(:new_question_answer).with(question.user, question, answer).and_call_original
      end

      answer.save!
    end
  end

end
