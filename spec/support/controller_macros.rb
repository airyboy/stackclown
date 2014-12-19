module ControllerMacros
  def sign_in_user
    let!(:signed_user){ create(:user) }
    before do
      login_user(signed_user)
    end
  end
end