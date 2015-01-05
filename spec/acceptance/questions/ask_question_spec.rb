require 'acceptance_helper'

feature 'Asking a question', %q{
    In order to ask a question
    As a user
    I want to be able to submit a question
 } do
  given!(:user) { create(:foo_user) }
  scenario 'Registered user tries to ask a question' do
    login_user_post('foo@bar.com', 'qwerty123')
    visit root_path
    click_on 'Ask question'

    fill_in 'Title', with: 'new question'
    fill_in 'Body', with: 'new question body'
    fill_in 'Tags', with: 'couple,tags'
    click_on 'Create'

    expect(page).to have_content 'Your question was created'
    expect(page).to have_content 'new question'
    expect(page).to have_content 'new question body'
    expect(page).to have_content 'couple'
    expect(page).to have_content 'tags'
  end

  scenario 'Non-registered user tries to ask a question' do
    visit root_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Please login first.')
    expect(page).to have_field :email
    expect(page).to have_field :password
  end
end