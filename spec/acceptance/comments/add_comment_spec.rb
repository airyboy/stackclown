require 'acceptance_helper'

feature 'Commenting on a question or an answer', %q{
    In order to give note for an answer or a question
    As a user
    I want to be able to submit a comment
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Signed-in user' do
    background do
      sign_in(user)
      visit question_answers_path(question)
    end

    scenario 'tries to comment on an answer', js: true do
      within '.answers' do
        click_on 'add a comment'
        fill_in 'Your comment', with: 'some comment'
        click_on 'Post'
        expect(page).to have_content 'some comment'
      end
    end

    scenario 'tries to add a comment with wrong data', js: true do
      within '.answers' do
        click_on 'add a comment'
        fill_in 'Your comment', with: ''
        click_on 'Post'
        expect(page).to have_content "can't be blank"
      end
    end

    scenario 'tries to comment on a question', js: true do
      within '.full-question' do
        click_on 'add a comment'
        fill_in 'Your comment', with: 'some comment'
        click_on 'Post'
        expect(page).to have_content 'some comment'
      end
    end
  end

  scenario 'Non signed in user tries to comment' do
    visit question_answers_path(question)

    expect(page).not_to have_link 'add a comment'
  end
end