require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 when there is no access_token' do
        get 'api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 when access_token is invalid' do
        get 'api/v1/profiles/me', format: :json, access_token: '8374789'
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    before { get 'api/v1/profiles/me', format: :json, access_token: access_token.token }

    it 'returns 200' do
      expect(response).to be_success
    end

    it 'should contain email' do
      expect(response.body).to be_json_eql(user.email.to_json).at_path('email')
    end

    it 'should contain id' do
      expect(response.body).to be_json_eql(user.id.to_json).at_path('id')
    end

    it 'should contain screen_name' do
      expect(response.body).to be_json_eql(user.screen_name.to_json).at_path('screen_name')
    end

    it 'should not contain crypted_password' do
      expect(response.body).not_to have_json_path('crypted_password')
    end
  end

end