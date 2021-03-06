FactoryGirl.define do
  factory :question do
    title 'How patch KDE under FreeBSD?'
    body 'A long body.'*40
    tags_comma_separated 'first-tag,second-tag'
    user

    factory :question_w_comments do
      after(:create) do |question|
        question.comments << create(:comment, commentable: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title 'How patch KDE under FreeBSD?'
    tags_comma_separated 'first-tag,second-tag'
    body nil	
  end

  factory :attachment do
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/public/images/foo.png')))
  end

  factory :answer do
    body 'Answer body'*40
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

  factory :tag do
    sequence :tag_name do |n|
      "tag#{n}"
    end

  end

  factory :comment do
    body 'RTFM'
    user
  end

  factory :comment_to_question, class: 'Comment' do
  	body 'RTFM'
    user
    association :commentable, :factory => :question
  end

  factory :comment_to_answer, class: 'Comment' do
    body 'RTFM'
    user
    association :commentable, :factory => :answer
  end

  factory :user do
    sequence :email do |n|
      "foo#{n}@bar.com"
    end

    sequence :screen_name do |n|
      "Ivan_#{n}"
    end

    password 'qwerty123'
    password_confirmation 'qwerty123'
    salt  'asdasdastr4325234324sdfds'
    crypted_password  Sorcery::CryptoProviders::BCrypt.encrypt('secret',
                                                               'asdasdastr4325234324sdfds')
  end

  factory :foo_user, class: 'User' do
    email 'foo@bar.com'
    password 'qwerty123'
    password_confirmation 'qwerty123'
    salt  'asdasdastr4325234324sdfds'
    crypted_password  Sorcery::CryptoProviders::BCrypt.encrypt('secret',
                                                               'asdasdastr4325234324sdfds')
  end

  factory :authentication do
    uid '123456'
    provider 'twitter'
  end

  factory :oauth_application,  class: Doorkeeper::Application do
    name 'test'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid '9494949'
    secret '9399x2u93nxe'
  end

  factory :access_token,  class: Doorkeeper::AccessToken do
    application { create(:oauth_application) }
    resource_owner_id { create(:user).id }
  end

  factory :subscription do
    user
    question
  end

  factory :vote do
    user
    points 1
    association :votable, :factory => :question
  end
end