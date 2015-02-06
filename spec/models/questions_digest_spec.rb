require 'rails_helper'

RSpec.describe QuestionsDigest, :type => :model do
  describe '.daily_digest' do
    it 'should send digest to every user' do
      User.all.each do |user|
        expect(DigestMailer).to receive(:daily_digest).with(user, QuestionsDigest.past_day_questions)
      end
      QuestionsDigest.daily_digest
    end
  end
end
