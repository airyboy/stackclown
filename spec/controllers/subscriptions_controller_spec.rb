require 'rails_helper'

RSpec.describe SubscriptionsController, :type => :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST#create' do
    before { login_user(user) }
    it 'should add a new subscription for the user' do
      expect{ post :create, question_id: question.id, format: :json }.to change(Subscription, :count).by(1)
    end

    it 'should create a correct subscription' do
      post :create, question_id: question.id, format: :json
      expect(Subscription.first.user).to eq user
      expect(Subscription.first.question).to eq question
    end
  end

  describe 'DELETE#destroy' do
    let!(:subscription) { create(:subscription, user: user) }

    it 'should destroy the subscription' do
      login_user(user)
      expect{ delete :destroy, id: subscription.id,  format: :json }.to change(Subscription, :count).by(-1)
    end
  end
end
