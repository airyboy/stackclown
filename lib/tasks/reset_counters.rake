namespace :db do
  desc 'Resets counter cache'
  task reset_counters: :environment do
    reset_users
    reset_questions
  end
end

def reset_users
  User.reset_column_information
  User.find_each do |u|
    User.reset_counters u.id, :questions
    User.reset_counters u.id, :answers
    User.reset_counters u.id, :comments
  end
end

def reset_questions
  Question.find_each do |q|
    Question.reset_counters q.id, :answers
  end
end