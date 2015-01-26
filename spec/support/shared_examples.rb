shared_examples 'action requiring signed in user' do
  context 'when user is not signed in' do
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to login_path
    end
  end
end

shared_examples 'action requiring to own an object' do
  let(:user) { create(:user) }
  it 'should respond with 403 error' do
    login_user(user)
    action
    expect(response.status).to eq 403
  end
end