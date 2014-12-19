shared_examples 'action requiring signed in user' do
  context 'when user is not signed in' do
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to new_user_session_path
    end
  end
end