class QuestionsDigest
  def self.daily_digest
    User.find_each.each do |user|
      DigestMailer.daily_digest(user, Question.yesterday)
    end
  end
end
