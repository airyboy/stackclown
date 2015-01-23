require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:user) { create(:user) }
  describe 'GET#email' do
    it_should_behave_like 'action requiring signed in user' do
      let(:action) { get :email }
    end

    context 'when user is signed in' do
      before do
        login_user(user)
        get :email
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'resets user email to empty value' do
        expect(user.email).to eq ''
      end
    end
  end

  describe 'POST#submit_email' do
    it_should_behave_like 'action requiring signed in user' do
      let(:action) { patch :submit_email, user: {email: 'some@new.com'} }
    end

    context 'when user is signed in' do
      before do
        login_user(user)
        patch :submit_email, user: {email: 'some@new.com'}
      end

      it 'updates email to the new one' do
        user.reload
        expect(user.email).to eq 'some@new.com'
      end

      it 'redirects to root path' do
        expect(user.email).to eq 'some@new.com'
      end
    end
  end
end
