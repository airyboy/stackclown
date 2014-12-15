namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_questions
    make_answers
    make_comments
  end
end

def make_questions
  10.times do |n|
    title = "Question N#{n}"
    body = "I wanna to ask about #{n}"
    Question.create(title: title, body: body)
  end
end

def make_answers
  questions = Question.all
  questions.each do |q|
    5.times do |n|
      q.answers.create(body: "somebody #{n}")
    end
  end
end

def make_comments
  questions = Question.all
  questions.each do |q|
    2.times do |n|
      q.comments.create(body: "comment N#{n}")
    end
  end
end