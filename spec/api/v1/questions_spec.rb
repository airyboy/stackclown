require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET #index' do
    it_should_behave_like 'action that forbids unauthorized access', :get, 'api/v1/questions', {}

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question ) }

      before { get 'api/v1/questions', format: :json, access_token: access_token.token }

      it 'should return 200' do
        expect(response).to be_success
      end

      it 'should return a list of question' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w{id title body created_at updated_at}.each do |attr|
        it "should contain #{attr}" do
          q = questions.first
          expect(response.body).to be_json_eql(q.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'should be included into question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w{id body created_at updated_at}.each do |attr|
          it "should contain #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }

    it_behaves_like 'action that forbids unauthorized access', :get, "api/v1/questions/1", question: 1

    before { get "api/v1/questions/#{question.id}", question: question, format: :json, access_token: access_token.token }

    it 'should return 200' do
      expect(response).to be_success
    end

    %w{id title body created_at updated_at}.each do |attr|
      it "should contain attribute: #{attr}" do
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
      end
    end

    it 'should not have answers' do
      expect(response.body).not_to have_json_path('question/answers')
    end

    context 'comments' do
      it 'should be included into the question' do
        expect(response.body).to have_json_size(2).at_path('question/comments')
      end

      %w{id body created_at updated_at}.each do |attr|
        it "should contain attribute: #{attr}" do
          expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json)
                                       .at_path("question/comments/0/#{attr}")
        end
      end
    end

    context 'attachments' do
      it 'should be included into the  question' do
        expect(response.body).to have_json_size(2).at_path('question/attachments')
      end

      it 'should contain attribute: url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json)
                                     .at_path('question/attachments/0/url')
      end
    end
  end

  describe 'POST #create' do
    let(:post_request) { post 'api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }

    it_behaves_like 'action that forbids unauthorized access', :post, 'api/v1/questions', question: {}

    it 'should return 201' do
      post_request
      expect(response.status).to eq 201
    end

    it 'should create a new question' do
      expect{ post_request }.to change(Question, :count).by(1)
    end

    it 'should save to the DB the correct question' do
      post_request
      q = Question.first
      expect(q.title).to eq create(:question).title
      expect(q.body).to eq create(:question).body
      expect(q.tags_comma_separated).to eq create(:question).tags_comma_separated
    end

    context 'with invalid attributes' do
      let(:post_request_invalid) { post 'api/v1/questions', question: attributes_for(:invalid_question), format: :json, access_token: access_token.token }

      it 'should return 422' do
        post_request_invalid
        expect(response.status).to eq 422
      end

      it "shouldn't save the question to the DB" do
        expect{ post_request_invalid }.not_to change(Question, :count)
      end

      it 'should return errors' do
        post_request_invalid
        expect(response.body).to have_json_path('errors')
      end
    end
  end
end