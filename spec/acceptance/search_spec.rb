require 'acceptance_helper'

feature 'Searching website', %q{
    In order to find some stuff
    As a guest/user
    I want to be able to look for some keyword
 } do

  let!(:questions) { create_list(:question, 2, title: 'keyword') }

  scenario 'Guest user tries to perform search from navbar' do
    visit root_path
    fill_in 'q', with: 'keyword'
    click_on 'Go'
    expect(page.current_path).to eq search_path
    expect(page).to have_content 'Your search returned no matches.'
  end

  scenario 'Guest user tries to perform advanced search' do
    visit search_path

    within '.row' do
      fill_in 'q', with: 'abracadabra'
      check 'questions'
      check 'answers'
      check 'users'
      check 'comments'
      click_on 'Go'
      expect(page).to have_content 'Your search returned no matches.'
    end
  end
end