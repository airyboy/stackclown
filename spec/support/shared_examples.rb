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

shared_examples 'voting up' do
  it 'should add vote for answer' do
    expect{ resource.upvote }.to change(Vote, :count).by(1)
  end

  it 'should create positive point' do
    vote = resource.upvote
    expect(vote.points).to eq 1
  end

  it 'should not be able to upvote twice' do
    resource.upvote
    expect{ resource.upvote }.not_to change(Vote, :count)
  end

  it 'should be able to change his vote' do
    vote = resource.downvote
    expect{ resource.upvote }.not_to change(Vote, :count)
    expect(vote.reload.points).to eq 1
  end
end

shared_examples 'voting down' do
  it 'should add vote for answer' do
    expect{ resource.downvote }.to change(Vote, :count).by(1)
  end

  it 'should create negative point' do
    vote = resource.downvote
    expect(vote.points).to eq -1
  end

  it 'should not be able to downvote twice' do
    resource.downvote
    expect{ resource.downvote }.not_to change(Vote, :count)
  end

  it 'should be able to change his vote' do
    vote = resource.upvote
    expect{ resource.downvote }.not_to change(Vote, :count)
    expect(vote.reload.points).to eq -1
  end
end

shared_examples 'voting action' do
  let!(:user) { create(:user) }

  context 'when user is signed in' do
    before { login_user(user) }

    it 'should be able to vote for the answer' do
      expect{ action }.to change(Vote, :count).by(1)
    end

    it 'should not be able to vote for his answer' do
      expect{ my_action }.not_to change(Vote, :count)
    end
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

