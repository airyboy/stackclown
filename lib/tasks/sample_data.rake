namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_user
    make_questions
    make_answers
    make_comments
  end
end

def make_user
  5.times do |u|
    email = "foo#{u}@bar.com"
    password = 'qwerty123'
    password_confirmation = 'qwerty123'
    User.create(email: email, password: password, password_confirmation: password_confirmation)
  end
end

def make_questions
  10.times do |n|
    title = "Question N#{n}"
    body = "I wanna to ask about #{n}"
    user = User.find_by(email: "foo#{rand(4)}@bar.com")
    Question.create(title: title, body: body, user: user)
  end
end

def make_answers
  questions = Question.all
  questions.each do |q|
    5.times do |n|
      user = User.find_by(email: "foo#{rand(4)}@bar.com")
      q.answers.create(body: "somebody #{n}", user: user)
    end
  end
end

def make_comments
  questions = Question.all
  questions.each do |q|
    2.times do |n|
      user = User.find_by(email: "foo#{rand(4)}@bar.com")
      q.comments.create(body: "comment N#{n}", user: user)
    end
  end
end