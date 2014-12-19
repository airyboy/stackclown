module Sorcery
  module TestHelpers
    module Rails
      module Integration
        def login_user_post(user, password)
          page.driver.post(user_sessions_url, { email: user, password: password })
        end

        def sign_in(user)
          visit new_user_session_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'qwerty123'
          click_on 'Sign in'
        end
      end
    end
  end
end