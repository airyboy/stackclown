require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    puts 'Making users'
    make_user
    puts 'Making tags'
    make_tags
    puts 'Making questions'
    make_questions
    puts 'Making answers'
    make_answers
    puts 'Making comments'
    make_comments
  end
end

def make_user
  5.times do |u|
    screen_name = Faker::Name.name
    email = Faker::Internet.free_email
    password = 'qwerty123'
    password_confirmation = 'qwerty123'
    User.create(email: email, screen_name: screen_name, password: password, password_confirmation: password_confirmation)
  end
  User.create(screen_name: 'Foo Bar', email: 'foo@bar.com', password: 'qwerty123', password_confirmation: 'qwerty123', admin: true)
end

def users
  @users ||= User.all
end

def random_user
  user_index = rand(4)
  user = users[user_index]
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
    user = random_user
    tags_count = 1 + rand(3)
    tags = Array.new
    tags_count.times do |n1|
      tags << Tag.find(1 + rand(9)).tag_name
    end
    q = Question.create(title: title, body: body, user: user, tags_comma_separated: tags.join(','))
    puts q.errors.full_messages unless q.save
  end
end

def make_answers
  questions = Question.all
  questions.each do |q|
    count = 4 + rand(3)
    count.times do |n|
      user = random_user
      q.answers.create(body: Faker::Lorem.paragraph, user: user)
    end
  end
end

def make_comments
  questions = Question.all
  questions.each do |q|
    count = 1 + rand(3)
    count.times do |n|
      user = random_user
      q.comments.create(body: Faker::Lorem.paragraph, user: user)
    end
  end
end