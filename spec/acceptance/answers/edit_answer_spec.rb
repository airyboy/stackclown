require_relative 'acceptance_helper'

feature 'Edit an answer', %q{
    In order to correct an answer of a question
    As an author
    I want to be able to edit an answer of the question
 } do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  let!(:other_user) { create(:user) }
  let!(:other_question) { create(:question, user: user) }
  let!(:others_answer) { create(:answer, question: other_question, user: other_user) }

  before { visit question_answers_path(question) }

  scenario 'Non-registered user tries to edit an answer', js: true do
    expect(page).not_to have_link 'Edit'
  end

  describe 'Registered user' do

    before do
      sign_in(user)
      visit question_answers_path(question)
    end

    scenario 'author tries to edit an answer', js: true do
      within '.answers' do
        click_on 'edit'
      end

      expect(page).to have_content answer.body
      within '#myModal' do
        fill_in 'Body', with: 'new answer'
        click_on 'Save'
      end

      expect(current_path).to eq question_answers_path(question)
      within '.answers' do
        expect(page).to have_content 'new answer'
        expect(page).not_to have_content answer.body
      end

    end

    scenario 'tries to update the answer with invalid data', js: true do
      within '.answers' do
        click_on 'edit'
      end

      within '#myModal' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end

    end

    scenario "tries to alter other's answer", js: true do
      visit question_answers_path(other_question)

      within '.answers' do
        expect(page).not_to have_link 'edit'
      end
    end
  end



end