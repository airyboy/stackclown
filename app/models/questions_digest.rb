class QuestionsDigest
  def self.daily_digest
    User.find_each.each do |user|
      DigestMailer.daily_digest(user, past_day_questions)
    end
  end

  def self.past_day_questions
    Question.where(created_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day)
  end
end
