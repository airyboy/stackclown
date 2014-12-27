require 'acceptance_helper'

feature 'Attaching file to an answer', %q{
    In order to give an example for answer
    As a user
    I want to be able to attach a file to the answer
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question) }

  scenario 'Registered user tries to attach file to answer', js: true do
    sign_in(user)
    visit question_answers_path(question)

    fill_in 'Your answer', with: 'answer body'
    attach_file 'File', "#{Rails.root}/spec/factories.rb"
    click_on 'Create'

    expect(page).to have_link 'factories.rb', href: '/uploads/attachment/file/1/factories.rb'
  end
end