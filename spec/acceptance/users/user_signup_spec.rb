require 'acceptance_helper'

feature 'Sign up a new user', %q{
    In order to use the website
    As a user
    I want to be able to signup
 } do
  describe 'User' do
    let(:existing_user) { create(:user) }
    scenario 'tries to sign up' do
      visit signup_path
      fill_in 'Email', with: 'heisenberg@email.com'
      fill_in 'Screen name', with: 'Heisenberg Werner'
      fill_in 'user_password', with: 'qwerty123'
      fill_in 'user_password_confirmation', with: 'qwerty123'
      click_on 'Sign Up'
      expect(page).to have_content 'Welcome! You have signed up successfuly.'
    end

    scenario 'tries to sign up with existing email' do
      visit signup_path
      fill_in 'Email', with: existing_user.email
      fill_in 'Screen name', with: 'Heisenberg Werner'
      fill_in 'user_password', with: 'qwerty123'
      fill_in 'user_password_confirmation', with: 'qwerty123'
      click_on 'Sign Up'
      expect(page).to have_content 'Email has already been taken'
    end
  end
end