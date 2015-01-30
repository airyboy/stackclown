require 'rails_helper'

describe 'Profile API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

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
    before { get 'api/v1/profiles/me', format: :json, access_token: access_token.token }

    it 'returns 200' do
      expect(response).to be_success
    end

    %w{email id screen_name}.each do |attr|
      it "should contain #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path("user/#{attr}")
      end
    end

    it 'should not contain crypted_password' do
      expect(response.body).not_to have_json_path('crypted_password')
    end
  end

  describe 'GET /users' do
    let!(:users) { create_list(:user, 2) }

    before { get 'api/v1/profiles', format: :json, access_token: access_token.token }

    it 'should return list of users' do
      expect(response.body).to have_json_size(2).at_path('profiles')
    end

    it 'should not include the authenticated user' do
      # it doesn't work, though according to json_spec documentation it should!
      # expect(response.body).not_to include_json(%("#{user.email}"))
      json = JSON.parse(response.body)
      expect(json['profiles'].select {|email| email['email'] == user.email}).to be_empty
    end
  end

end