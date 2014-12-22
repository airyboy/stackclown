require_relative 'acceptance_helper'

feature 'User sign in', %q{
    In order to ask a question
    As a user
    I want to be able to sign in
 } do

  scenario 'Registered user tries to sign in' do
    User.create!(email: 'foo@bar.com', password: 'qwerty123', password_confirmation: 'qwerty123')

    visit '/signin'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: 'qwerty123'
    click_on 'Sign in'

    expect(page).to have_content('Login successful')
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    visit '/signin'
    fill_in 'Email', with: 'bar@foo.com'
    fill_in 'Password', with: 'qwerty123'
    click_on 'Sign in'

    expect(page).to have_content('Login failed')
  end
end