require 'acceptance_helper'

feature 'Attaching file to a question', %q{
    In order to give an example
    As an author
    I want to be able to attach a file to a question
 } do
  given!(:user) { create(:foo_user) }
  scenario 'Registered user tries to ask a question', js: true do
    sign_in(user)
    visit root_path
    click_on 'Ask question'

    fill_in 'question_title', with: 'new question'
    fill_in 'question_body', with: 'new question body'

    fill_in 'tags_comma_separated', with: 'couple,tags'
    click_on 'attach files'
    sleep 2
    page.execute_script("$('#attachment-1').show()")
    attach_file 'attachment-1', "#{Rails.root}/spec/factories.rb"
    # sleep 5
    # page.execute_script("$('#attachment-2').show()")
    # attach_file 'attachment-2', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'factories.rb', href: '/uploads/attachment/file/1/factories.rb'
  end
end