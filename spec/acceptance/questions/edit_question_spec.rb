require 'acceptance_helper'

feature 'Editing a question', %q{
    In order to edit a question
    As an author
    I want to be able to edit a question
 } do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'The author' do
    before do
      sign_in(user)
      visit question_answers_path(question)

      within '.full-question' do
        click_on 'edit'
      end
    end

    scenario 'tries to edit a question', js: true do
      fill_in 'Title', with: 'modified title'
      fill_in 'Body', with: 'modified body'
      click_on 'Save'

      expect(page).to have_content 'modified title'
      expect(page).to have_content 'modified body'
    end

    scenario 'tries to submit an updated question with wrong data', js: true do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Save'

      expect(page).to have_content "can't be blank"
    end
  end


  scenario 'Non-registered user tries to edit a question' do
    visit question_answers_path(question)

    within '.full-question' do
      expect(page).not_to have_link 'edit'
    end
  end
end