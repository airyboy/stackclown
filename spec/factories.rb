FactoryGirl.define do
  factory :question do
    title 'Question title'
    body 'A long body.'*40
  end

  factory :answer do
    body 'Answer body'*40
    question
  end
end