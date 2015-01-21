require 'acceptance_helper'

feature 'Removing a comment', %q{
    In order to remove comment for an answer or a question
    As an author of comment
    I want to be able to remove my comment
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question, body: 'some comment', user: user) }

  describe 'Signed-in user' do
    background do
      sign_in(user)
      visit question_answers_path(question)
    end

    scenario 'tries to remove the comment', js: true do
      within '.comment' do
        click_on 'x'
        sleep 2
        expect(page).not_to have_content 'some comment'
      end
    end
  end

  scenario 'Non signed in user tries to remove comment' do
    visit question_answers_path(question)

    within '.comments' do
      expect(page).not_to have_link 'x'
    end
  end
end