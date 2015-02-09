require 'acceptance_helper'

feature 'Subscribing to a question answers', %q{
    In order to keep up to date
    As a user
    I want to be able to subscribe to a question
 } do
  given!(:user) { create(:foo_user) }
  given!(:question) { create(:question) }
  scenario 'Registered user tries to subscribe to a question', js: true do
    sign_in(user)
    visit question_answers_path(question)

    click_on 'Subscribe'
    expect(page).to have_content('Unsubscribe')
  end

  scenario 'Registered user tries to unsubscribe from a question', js: true do
    question.subscriptions.create(user: user)
    sign_in(user)
    visit question_answers_path(question)

    click_on 'Unsubscribe'
    expect(page).to have_content('Subscribe')
  end

  scenario 'Non-registered user tries to subscribe to a question' do
    visit question_answers_path(question)

    expect(page).not_to have_content('Subscribe')
    expect(page).not_to have_content('Unsubscribe')
  end
end