require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should have_many(:attachments) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }
  it { should have_many(:tags) }
  it { should have_many :subscriptions }
  it { should have_many :votes }
  it { should belong_to(:user) }
  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :tags_comma_separated }

  it { should ensure_length_of(:title).is_at_most(GlobalConstants::QUESTION_TITLE_MAX_LENGTH) }
  it { should ensure_length_of(:body).is_at_most(GlobalConstants::QUESTION_BODY_MAX_LENGTH) }

  describe '.add_author_subscription' do
    let(:user) { create(:user) }
    it 'should create subscription for an author' do
      question = build(:question, user: user)
      expect{ question.save! }.to change(Subscription, :count).by(1)
    end

    it 'should create correct subscription for an author' do
      question = create(:question, user: user)
      expect(Subscription.first.user).to eq user
      expect(Subscription.first.question).to eq question
    end
  end

  describe 'scope :yesterday' do
    let!(:yesterday_questions) { create_list(:question, 2, created_at: 1.day.ago) }
    let!(:past_yesterday_questions) { create_list(:question, 2, created_at: 2.day.ago) }
    let!(:old_questions) { create_list(:question, 2, created_at: 1.month.ago) }

    it 'should return only yesterday questions' do
      expect(Question.yesterday).to match_array(yesterday_questions)
    end
  end

  describe 'Question.upvote' do
    it_behaves_like 'voting up' do
      let!(:resource) { create(:question) }
    end
  end

  describe 'Question.downvote' do
    it_behaves_like 'voting down' do
      let!(:resource) { create(:question) }
    end
  end
end
