require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question) }

  describe 'GET /index' do
    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get "api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'should return 200' do
        expect(response).to be_success
      end

      it 'should return a list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w{id body created_at updated_at best user_id question_id}.each do |attr|
        it "should contain #{attr}" do
          a = answers.first
          expect(response.body).to be_json_eql(a.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }

    before { get "api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

    it 'should return 200' do
      expect(response).to be_success
    end

    %w{id body created_at updated_at best user_id question_id}.each do |attr|
      it "should contain #{attr}" do
        expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
      end
    end

    context 'attachments' do
      it 'should be included into the answer' do
        expect(response.body).to have_json_size(2).at_path('answer/attachments')
      end

      it 'should contain attribute: url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json)
                                     .at_path('answer/attachments/0/url')
      end
    end

    context 'comments' do
      it 'should be included into the answer' do
        expect(response.body).to have_json_size(2).at_path('answer/comments')
      end

      %w{id body created_at updated_at}.each do |attr|
        it "should contain attribute: #{attr}" do
          expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json)
                                       .at_path("answer/comments/0/#{attr}")
        end
      end
    end


  end
end