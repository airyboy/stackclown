FactoryGirl.define do
  factory :question do
    title 'How patch KDE under FreeBSD?'
    body 'A long body.'*40
  end

  factory :invalid_question, class: 'Question' do
    title 'How patch KDE under FreeBSD?'
    body nil	
  end

  factory :answer do
    body 'Answer body'*40
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

  factory :tag do
    tag_name "linux"
  end

  factory :comment do
  	body 'RTFM'

    association :commentable, :factory => :question
  end


end