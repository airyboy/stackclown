FactoryGirl.define do
  factory :question do
    title 'How patch KDE under FreeBSD?'
    body 'A long body.'*40
  end

  factory :answer do
    body 'Answer body'*40
    question
  end

  factory :tag do
    tag_name "linux"
  end

  factory :comment do
  	body "RTFM"
  	commentable question
  end
end