shared_examples 'action requiring signed in user' do
  context 'when user is not signed in' do
    it 'redirects to sign in page' do
      action
      expect(response).to redirect_to login_path
    end
  end
end

shared_examples 'json action requiring signed in user' do
  context 'when user is not signed in' do
    it 'redirects to sign in page' do
      action
      expect(response.status).to eq 422
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

shared_examples 'action that forbids unauthorized access' do |verb, path, options|
  context 'unauthorized' do
    it 'returns 401 when there is no access_token' do
      send(verb, path, {format: :json}.merge(options))
      expect(response.status).to eq 401
    end

    it 'returns 401 when access_token is invalid' do
      send(verb, path, {format: :json, access_token: '8374789'}.merge(options))
      expect(response.status).to eq 401
    end
  end
end