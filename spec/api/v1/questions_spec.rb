require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 when there is no access_token' do
        get 'api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 when access_token is invalid' do
        get 'api/v1/questions', format: :json, access_token: '8374789'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question ) }

      before { get 'api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200' do
        expect(response).to be_success
      end

      it 'should return a list of question' do
        expect(response.body).to have_json_size(2 )
      end

      %w{id title body created_at updated_at}.each do |attr|
        it "should contain #{attr}" do
          q = questions.first
          expect(response.body).to be_json_eql(q.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do
        it 'should be included in question' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w{id body created_at updated_at}.each do |attr|
          it "should contain #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end