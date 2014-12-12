require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question) }
    before { get :index, question_id: question  }

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'populates an array of answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'assigns a new answer to @new_answer' do
      expect(assigns(:new_answer)).to be_a_new(Answer)
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
        expect(response).to redirect_to question_answers_path(question)
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
        expect(response).to render_template(:index)
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
