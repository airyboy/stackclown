require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  let(:questions) { create(:question, 2, title: 'keyword') }

  describe 'GET #find' do
    it 'should render search result' do
      get :find, q: 'keyword'
      expect(response).to render_template :find
    end
  end
end
