require 'acceptance_helper'

feature 'Deleting an answer', %q{
    In order to remove an answer
    As an author
    I want to be able to remove the answer
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given!(:other_user) { create(:user) }
  given!(:other_question) { create(:question, user: other_user) }
  given!(:other_answer) { create(:answer, question: other_question, user: other_user) }

  describe 'Registered user' do
    before do
      sign_in(user)
    end

    scenario 'tries to remove his answer', js: true do
      visit question_answers_path(question)
      within '.answers' do
        handle_js_confirm do
          click_on 'x'
        end
        expect(page).not_to have_content answer.body
      end
    end

    scenario 'tries to remove his answer, but changes his mind', js: true do
      visit question_answers_path(question)
      within '.answers' do
        handle_js_confirm(false) do
          click_on 'x'
        end
        expect(page).to have_content answer.body
      end
    end

    scenario "tries to remove other's answer" do
      visit question_answers_path(other_question)
      within '.answers' do
        expect(page).not_to have_link 'x'
      end
    end
  end

  scenario 'Non-registered user tries to remove an answer' do
    visit question_answers_path(other_question)

    expect(page).not_to have_link 'x'
  end
end