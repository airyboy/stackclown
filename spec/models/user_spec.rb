require 'rails_helper'

RSpec.describe User, :type => :model do
   it { should have_many :questions }
   it { should have_many :answers }
   it { should have_many :comments }

   it { should respond_to :email }
   it { should respond_to :password }
   it { should respond_to :password_confirmation }
   it { should respond_to :screen_name }
   it { should respond_to :avatar }


   describe '#setup_oauth_user' do
      let(:twitter_user) { User.new(screen_name: 'Johny') }
      let(:fb_user) { User.new(screen_name: 'Johny', email: 'some@email.com') }

      it 'should generate fake email' do
         expect((User.setup_oauth_user('twitter', twitter_user)).email).to eq 'johny@twitter.com'
      end

      it 'should generate password' do
         expect((User.setup_oauth_user('twitter', twitter_user)).password).not_to be_nil
         expect((User.setup_oauth_user('twitter', twitter_user)).password_confirmation).not_to be_nil
      end

      it 'should not overwrite email if it was given' do
         expect((User.setup_oauth_user('facebook', fb_user)).email).to eq 'some@email.com'
      end
   end

end