require 'rails_helper'

RSpec.describe QuestionsDigest, :type => :model do
  let!(:yesterday_questions) { create_list(:question, 2, created_at: 1.day.ago) }
  let!(:old_questions) { create_list(:question, 2, created_at: 1.month.ago) }

  describe '.daily_digest' do
    it 'should send digest to every user' do
      User.all.each do |user|
        expect(DigestMailer).to receive(:daily_digest).with(user, QuestionsDigest.past_day_questions)
      end
      QuestionsDigest.daily_digest
    end
  end

  describe '.past_day_questions' do
    it 'should return only yesterday questions' do
      expect(QuestionsDigest.past_day_questions).to match_array(yesterday_questions)
    end
  end
end
