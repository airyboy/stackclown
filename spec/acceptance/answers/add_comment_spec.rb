require 'acceptance_helper'

feature 'Answering a question', %q{
    In order to give an answer to a question
    As a user
    I want to be able to submit an answer to the question
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario '' do
    visit question_answers_path(question)

    click_on 'add comment'

    fill_in 'Your comment', with: 'some comment'
    click_on 'Save'

    expect(page).to have_content 'some comment'
  end

end