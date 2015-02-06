require 'acceptance_helper'

feature 'Searching website', %q{
    In order to find some stuff
    As a guest/user
    I want to be able to look for some keyword
 } do

  let!(:questions) { create(:question, 2, title: 'keyword') }

  scenario 'Guest user tries to perform search' do
    visit root_path
    fill_in 'Search', with: 'keyword'
    click_on 'Go'
    expect(page.url).to eq results_url
  end
end