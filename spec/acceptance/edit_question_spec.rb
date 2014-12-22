require_relative 'acceptance_helper'

feature 'Edit a question', %q{
    In order to correct an answer to a question
    As an author
    I want to be able to edit an answer to the question
 } do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before { visit question_answers_path(question) }

  scenario 'Non-registered user tries to edit an answer', js: true do
    expect(page).not_to have_link 'Edit'
  end

  describe 'Registered user' do
    before { sign_in(user) }
    scenario 'author tries to edit an answer', js: true do
      within '.answers' do
        click_on 'Edit'
      end

      expect(page).to have_content answer.body
      fill_in 'Your answer', with: 'new answer'
      click_on 'Save'

      expect(current_path).to eq question_answers_path(question)
      within '.answers' do
        expect(page).to have_content 'new answer'
        expect(page).not_to have_content answer.body
      end

    end

    scenario "tries to alter other's an answer" do

    end
  end



end