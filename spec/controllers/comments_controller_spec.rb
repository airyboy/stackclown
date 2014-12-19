require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  post :create, answer_id: answer, comment: attributes_for(:comment_to_answer) }
    end

    context 'when user is signed in' do
      before { login_user(user) }

      context 'when attributes are valid' do
        it 'should save the new comment of the answer to the DB' do
          expect do
            post :create, answer_id: answer, comment: attributes_for(:comment_to_answer)
          end.to change(answer.comments, :count).by(1)
        end

        it 'should save the new comment of the question to the DB' do
          expect do
            post :create, question_id: question, comment: attributes_for(:comment_to_answer)
          end.to change(question.comments, :count).by(1)
        end

        it 'should redirect to question' do
          post :create, answer_id: answer, comment: attributes_for(:comment_to_answer)
          expect(response).to redirect_to question_answers_path(question)
        end
      end

      context 'when attributes are invalid' do
        it 'should not save the new comment of the answer to the DB' do
          expect do
            post :create, answer_id: answer, comment: { body:nil }
          end.not_to change(answer.comments, :count)
        end

        it 'should not save the new comment of the question to the DB' do
          expect do
            post :create, question_id: question, comment: { body:nil }
          end.not_to change(question.comments, :count)
        end

        it 'should populate an array of answers' do
          post :create, question_id: question, comment: { body:nil }
          expect(assigns(:answers)).to match_array(question.answers.to_a)
        end

        it 'should render question answers with error' do
          post :create, answer_id: answer, comment: { body:nil }
          expect(response).to render_template 'answers/index'
        end
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:question_comment) { question.comments.create(body: 'new', user: user) }
    let!(:answer_comment) { answer.comments.create(body: 'new', user: user) }

    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  delete :destroy, id: question_comment }
    end

    context 'when user is signed in' do
      before { login_user(user) }

      context 'when question comment' do
        it 'should delete the comment of the question' do
          expect do
            delete :destroy, id: question_comment
          end.to change(question.comments, :count).by(-1)
        end

        it 'should redirect to question' do
          delete :destroy, id: question_comment
          expect(response).to redirect_to question_answers_path(question)
        end
      end

      context 'when answer comment' do
        it 'should delete the comment of the answer' do
          expect do
            delete :destroy, id: answer_comment
          end.to change(answer.comments, :count).by(-1)
        end

        it 'should redirect to question' do
          delete :destroy, id: answer_comment
          expect(response).to redirect_to question_answers_path(question)
        end
      end
    end
  end
end
