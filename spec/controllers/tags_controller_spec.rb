require 'rails_helper'

RSpec.describe TagsController, :type => :controller do

  let(:tag) { create(:tag) }
  describe 'GET #index' do
    let(:tags) { create_list(:tag, 2) }
    before { get :index }

    it 'populates an array of tags' do
      expect(assigns(:tags)).to match_array(tags)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: tag }

    it 'assigns @tag to tag' do
      expect(assigns(:tag)).to eq tag
    end

    it 'renders tag view' do
      expect(response).to render_template :show
    end
  end
end