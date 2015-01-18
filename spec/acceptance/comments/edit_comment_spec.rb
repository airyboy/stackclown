require 'acceptance_helper'

feature 'Editing a comment', %q{
    In order to correct comment for an answer or a question
    As a user
    I want to be able to edit a comment
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_comment) { create(:comment, commentable: question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer_comment) { create(:comment, commentable: answer, user: user) }

  describe 'Signed-in user' do
    background do
      sign_in(user)
      visit question_answers_path(question)
    end

    scenario 'tries to edit a comment of a question', js: true do
      within ".comments[data-resource='questions']" do
        click_on 'edit'
      end
      fill_in 'comment_body', with: 'altered comment'
      click_on 'Save'
      expect(page).to have_content 'altered comment'
    end

    scenario 'tries to save the comment with wrong data', js: true do
      within ".comments[data-resource='questions']" do
        click_on 'edit'
      end
      fill_in 'comment_body', with: ''
      click_on 'Save'
      expect(page).to have_content "can't be blank"
    end
  end

  scenario 'Non signed in user tries to comment' do
    visit question_answers_path(question)

    within ".comments[data-resource='questions']" do
      expect(page).not_to have_link 'edit'
    end
  end
end