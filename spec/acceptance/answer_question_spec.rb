require_relative 'acceptance_helper'

feature 'Answering a question', %q{
    In order to give an answer to a question
    As a user
    I want to be able to submit an answer to the question
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Registered user tries to answer a question', js: true do
    sign_in(user)
    visit question_answers_path(question)

    expect(current_path).to eq question_answers_path(question)
    fill_in 'Your answer', with: 'new answer'
    click_on 'Create'


    within '.answers' do
      expect(page).to have_content 'new answer'
    end
  end

  scenario ''

  scenario 'Non-registered user tries to answer a question' do
    visit question_answers_path(question)

    expect(page).not_to have_field 'Your answer'
  end
end