class UserMailer < ActionMailer::Base
  default from: "from@stackclown.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url  = "http://lvh.me:3000/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to StackClown")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    @url  = "http://lvh.me:3000/login"
    mail(:to => user.email,
         :subject => "Your account at Stackclown is now activated")
  end

  def new_question_answer(user, question, answer)
    @user = user
    @question = question
    @answer = answer

    mail(:to => user.email,
         :subject => "You've got the new answer")
  end
end
