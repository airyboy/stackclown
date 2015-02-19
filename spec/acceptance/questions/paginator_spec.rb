require 'acceptance_helper'

feature 'Pagination of questions list', %q{
    In order to see questions conviniently
    As a user
    I want to be able to see paginator
 } do

  given!(:user) { create(:foo_user) }
  scenario 'User sees root page with less than 10 questions', js: true do
    create_list(:question, 2, user: user)
    visit root_path

    expect(page).not_to have_css('.paginator')
  end

  scenario 'User sees root page with more than 10 questions', js: true do
    create_list(:question, 11, user: user)
    visit root_path

    expect(page).to have_css('.paginator')
  end
end