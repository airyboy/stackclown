class DigestMailer < ActionMailer::Base
  default from: "digest@stackclown.com"

  def daily_digest(user, questions)
    @greeting = "Hi, #{user.screen_name}"

    @questions = questions
    @date = @questions.first.created_at.strftime("%A, %M, %d")

    mail to: user.email
  end
end
