require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let!(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders partial new view' do
      expect(response).to render_template(partial: :new)
    end
  end

  describe 'POST #create' do
    context 'when attributes are valid' do
      it 'should save the new answer to the DB' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer)
        end.to change(question.answers, :count).by(1)
      end

      it 'should redirect to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when attributes are invalid' do
      it 'should not save the answer to the DB' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        end.not_to change(question.answers, :count)
      end

      it 'should redirect to the question with error message' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template(partial: 'new')
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(attributes_for(:answer)) }
    it 'should delete the answer' do
      expect do
        delete :destroy, question_id: question, id: answer
      end.to change(question.answers, :count).by(-1)
    end

    it 'should redirect to question' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to(question)
    end
  end
end
