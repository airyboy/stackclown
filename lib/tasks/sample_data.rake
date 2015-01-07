namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    make_user
    make_tags
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

def make_tags
  tags = %w{rails ruby dotnet windows mac nginx apache linux osx iphone}

  tags.each do |t|
    Tag.create(tag_name: t)
  end
end

def make_questions
  20.times do |n|
    title = Faker::Lorem.sentence
    body = Faker::Lorem.paragraph(6)
    user = User.find_by(email: "foo#{rand(4)}@bar.com")
    q = Question.create(title: title, body: body, user: user, tags_comma_separated: 'tag')
    2.times do |n1|
      t = Tag.find(1 + rand(9))
      puts q.assign_tag(t.tag_name)
    end
    puts q.errors.full_messages unless q.save
  end
end

def make_answers
  questions = Question.all
  questions.each do |q|
    count = 4 + rand(3)
    count.times do |n|
      user = User.find_by(email: "foo#{rand(4)}@bar.com")
      q.answers.create(body: Faker::Lorem.paragraph, user: user)
    end
  end
end

def make_comments
  questions = Question.all
  questions.each do |q|
    count = 1 + rand(3)
    count.times do |n|
      user = User.find_by(email: "foo#{rand(4)}@bar.com")
      q.comments.create(body: Faker::Lorem.paragraph, user: user)
    end
  end
end