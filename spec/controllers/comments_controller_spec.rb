require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  let!(:user) { create(:user) }
  let!(:other_user){ create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment, commentable: question) }

  describe 'GET #show' do
    render_views
    before { get :show, id: comment, format: :json }

    it 'renders question answers view' do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['body']).to eq comment.body
    end
  end

  describe 'POST #create' do
    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  post :create, answer_id: answer, comment: attributes_for(:comment_to_answer), format: :json }
    end

    context 'when user is signed in' do
      before { login_user(user) }

      context 'when attributes are valid' do
        it 'should save the new comment of the answer to the DB' do
          expect do
            post :create, answer_id: answer, comment: attributes_for(:comment_to_answer), format: :json
          end.to change(answer.comments, :count).by(1)
        end

        it 'should save the new comment of the question to the DB' do
          expect do
            post :create, question_id: question, comment: attributes_for(:comment_to_answer), format: :json
          end.to change(question.comments, :count).by(1)
        end

        it 'publishes an answer to subscribers' do
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", anything())
          post :create, question_id: question, comment: attributes_for(:comment_to_answer), format: :json
        end


      end

      context 'when attributes are invalid' do
        it 'should not save the new comment of the answer to the DB' do
          expect do
            post :create, answer_id: answer, comment: { body:nil }, format: :json
          end.not_to change(answer.comments, :count)
        end

        it 'should not save the new comment of the question to the DB' do
          expect do
            post :create, question_id: question, comment: { body:nil }, format: :json
          end.not_to change(question.comments, :count)
        end
      end

      context 'when format is json' do
        render_views
        let(:comm) { create(:comment_to_answer) }
        it 'should render the custom json' do
          post :create, answer_id: answer, comment: attributes_for(:comment_to_answer), format: :json
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['body']).to eq comm.body
          expect(parsed_body['commentable']['resource']).to eq "#{comm.commentable_type.downcase}s"
        end
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:question_comment) { question.comments.create(body: 'new', user: user) }
    let!(:answer_comment) { answer.comments.create(body: 'new', user: user) }

    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  delete :destroy, id: question_comment, format: :json }
    end

    context 'when user is signed in' do
      before { login_user(user) }

      context 'when question comment' do
        it 'should delete the comment of the question' do
          expect do
            delete :destroy, id: question_comment, format: :json
          end.to change(question.comments, :count).by(-1)
        end
      end

      context 'when answer comment' do
        it 'should delete the comment of the answer' do
          expect do
            delete :destroy, id: answer_comment, format: :json
          end.to change(answer.comments, :count).by(-1)
        end
      end
    end
  end

  describe 'PATCH #upvote' do
    it_behaves_like 'voting action' do
      let!(:comment) { create(:comment_to_answer, user: other_user) }
      let!(:my_comment) { create(:comment_to_answer, user: user) }
      let(:action) { patch :upvote, id: comment.id, format: :json }
      let(:my_action) { patch :upvote, id: my_comment.id, format: :json }
    end
  end

  describe 'PATCH #downvote' do
    it_behaves_like 'voting action' do
      let!(:comment) { create(:comment_to_answer, user: other_user) }
      let!(:my_comment) { create(:comment_to_answer, user: user) }
      let(:action) { patch :downvote, id: comment.id, format: :json }
      let(:my_action) { patch :downvote, id: my_comment.id, format: :json }
    end
  end
end
