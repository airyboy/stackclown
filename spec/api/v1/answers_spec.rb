require 'rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question) }

  describe 'GET #index' do
    it_behaves_like 'action that forbids unauthorized access', :get, "api/v1/questions/1/answers", {}

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

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }

    it_behaves_like 'action that forbids unauthorized access', :get, "api/v1/answers/1", {}

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

  describe 'POST #create' do
    let(:post_request) do
      post "api/v1/questions/#{question.id}/answers",\
       question_id: question.id, answer: attributes_for(:answer), format: :json, access_token: access_token.token
    end

    it_behaves_like 'action that forbids unauthorized access', :post, "api/v1/questions/1/answers", {question_id:1, answer: {}}

    it 'should return 201' do
      post_request
      expect(response.status).to eq 201
    end

    it 'should create a new answer' do
      expect{ post_request }.to change(Answer, :count).by(1)
    end

    it 'should create a correct answer' do
      post_request
      answer = Answer.first
      expect(answer.body).to eq create(:answer).body
      expect(question.answers.to_a).to include answer
    end

    context 'with invalid attributes' do
      let(:post_request_invalid) do
        post "api/v1/questions/#{question.id}/answers",\
       question_id: question.id, answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token
      end

      it 'should return 422' do
        post_request_invalid
        expect(response.status).to eq 422
      end

      it "shouldn't save the answer to the DB" do
        expect{ post_request_invalid }.not_to change(Answer, :count)
      end

      it 'should return errors' do
        post_request_invalid
        expect(response.body).to have_json_path('errors')
      end
    end
  end
end