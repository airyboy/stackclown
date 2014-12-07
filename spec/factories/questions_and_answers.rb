# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "Question title"
    body "A long body. "*40
  end

  factory :answer do
    body "Answer body"
    question
  end
end
