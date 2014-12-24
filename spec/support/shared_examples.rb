shared_examples 'action requiring signed in user' do
  context 'when user is not signed in' do
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to new_user_session_path
    end
  end
end

shared_examples 'action requiring to own an object' do
  let(:user) { create(:user) }
  it 'should respond with 401 error' do
    login_user(user)
    action
    expect(response.status).to eq 401
  end
end