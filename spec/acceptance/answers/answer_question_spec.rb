require 'acceptance_helper'

feature 'Answering a question', %q{
    In order to give an answer to a question
    As a user
    I want to be able to submit an answer to the question
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }

  describe 'Registered user' do
    before do
      sign_in(user)
      visit question_answers_path(question)
    end

    scenario ' tries to answer a question', js: true do
      expect(current_path).to eq question_answers_path(question)
      fill_in 'Your answer', with: 'new answer'
      click_on 'Create'


      within '.answers' do
        expect(page).to have_content 'new answer'
      end
    end

    scenario 'tries to answer a question with wrong data', js: true do
      fill_in 'Your answer', with: ''
      click_on 'Create'

      expect(page).to have_content "can't be blank"

    end
  end

  scenario 'Non-registered user tries to answer a question' do
    visit question_answers_path(question)

    expect(page).not_to have_field 'Your answer'
  end
end