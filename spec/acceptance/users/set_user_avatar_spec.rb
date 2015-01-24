require 'acceptance_helper'

feature 'Set user avatar', %q{
    In order to make him more prominent
    As a user
    I want to be able to upload my avatar image
 } do
  given!(:user) { create(:user) }

  scenario 'Signed in user tries to upload his avatar' do
    sign_in(user)
    visit edit_user_path
    attach_file 'avatar', "#{Rails.root}/public/images/foo.png"
    click_on 'Save'

    expect(page).to have_css('img', :src => '/uploads/avatars/foo.png')
  end
end