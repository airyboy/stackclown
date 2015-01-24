require 'rails_helper'

RSpec.describe OauthsController, :type => :controller do

  describe "GET#callback" do
    it 'logs in a linked user' do
      allow_any_instance_of(OauthsController).to receive(:login_from).with('facebook').and_return(Authentication.new)
      get :callback, provider: 'facebook', code: '123456'

      expect(response).to redirect_to root_path
    end

    it 'redirects new twitter user to email page' do
      allow_any_instance_of(OauthsController).to receive(:login_from).with('twitter').and_return(false)
      allow_any_instance_of(OauthsController).to receive(:create_from).with('twitter').and_return(User.new)

      get :callback, provider: 'twitter', code: '123'

      expect(response).to redirect_to '/users/email'
    end

    it 'redirects new facebook user to root' do
      allow_any_instance_of(OauthsController).to receive(:login_from).with('facebook').and_return(false)
      allow_any_instance_of(OauthsController).to receive(:create_from).with('facebook').and_return(User.new)

      get :callback, provider: 'facebook', code: '123'

      expect(response).to redirect_to root_path
    end
  end

  def stub_all_oauth2_requests!
    access_token    = double(OAuth2::AccessToken)
    allow(access_token).to receive(:token_param=)
    response        = double(OAuth2::Response)
    allow(response).to receive(:body) { {
                           "id"=>"123",
                           "user_id"=>"123", # Needed for Salesforce
                           "name"=>"Noam Ben Ari",
                           "first_name"=>"Noam",
                           "last_name"=>"Ben Ari",
                           "link"=>"http://www.facebook.com/nbenari1",
                           "hometown"=>{"id"=>"110619208966868", "name"=>"Haifa, Israel"},
                           "location"=>{"id"=>"106906559341067", "name"=>"Pardes Hanah, Hefa, Israel"},
                           "bio"=>"I'm a new daddy, and enjoying it!",
                           "gender"=>"male",
                           "email"=>"nbenari@gmail.com",
                           "timezone"=>2,
                           "locale"=>"en_US",
                           "languages"=>[{"id"=>"108405449189952", "name"=>"Hebrew"}, {"id"=>"106059522759137", "name"=>"English"}, {"id"=>"112624162082677", "name"=>"Russian"}],
                           "verified"=>true,
                           "updated_time"=>"2011-02-16T20:59:38+0000",
                           # response for VK auth
                           "response"=>[
                               {
                                   "uid"=>"123",
                                   "first_name"=>"Noam",
                                   "last_name"=>"Ben Ari"
                               }
                           ]}.to_json }
    allow(access_token).to receive(:get) { response }
    allow(access_token).to receive(:token) { "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3" }
    # access_token params for VK auth
    allow(access_token).to receive(:params) { { "user_id"=>"100500", "email"=>"nbenari@gmail.com" } }
    allow_any_instance_of(OAuth2::Strategy::AuthCode).to receive(:get_token) { access_token }
  end
end
