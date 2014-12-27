require 'acceptance_helper'

feature 'Attaching file to a question', %q{
    In order to give an example
    As an author
    I want to be able to attach a file to a question
 } do
  given!(:user) { create(:foo_user) }
  scenario 'Registered user tries to ask a question' do
    sign_in(user)
    visit root_path
    click_on 'Ask question'

    fill_in 'Title', with: 'new question'
    fill_in 'Body', with: 'new question body'
    attach_file 'File', "#{Rails.root}/spec/factories.rb"
    click_on 'Create'

    expect(page).to have_link 'factories.rb', href: '/uploads/attachment/file/1/factories.rb'
  end
end