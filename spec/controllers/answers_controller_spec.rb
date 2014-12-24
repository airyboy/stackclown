require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:others_answer) { create(:answer, user: other_user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question, user: user) }
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

    it 'assigns a new comment to @new_comment' do
      expect(assigns(:new_comment)).to be_a_new(Comment)
    end
  end

  describe 'GET #edit' do
    let!(:answer) { create(:answer, question: question, user: user) }

    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  get :edit, id: answer, format: :html }
    end

    context 'signed in user' do
      before do
        login_user(user)
        xhr :get, :edit, id: answer, format: :js
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    it_should_behave_like 'action requiring to own an object' do
      let(:action) { xhr :get, :edit, id: others_answer }
    end
  end

  describe 'POST #create' do
    let!(:answer) { create(:answer, question: question) }
    it_should_behave_like 'action requiring signed in user' do
      let(:action) {  post :create, question_id: question, answer: attributes_for(:answer) }
    end

    context 'when attributes are valid' do
      before { login_user(user) }
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
      before { login_user(user) }
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

  describe 'PATCH#update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    it_should_behave_like 'action requiring signed in user' do
      let(:action) { patch :update, id: answer, answer: {body: 'NewBody'}, format: :js }
    end

    context 'when attributes are valid' do
      before do
        login_user(user)
        patch :update, id: answer, answer: {body: 'NewBody'}, format: :js
      end

      it 'should assign answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'should update the answer attributes' do
        answer.reload
        expect(answer.body).to eq 'NewBody'
      end

      it 'should render update template' do
        expect(response).to render_template :update
      end
    end

    context 'when html format' do
      before do
        login_user(user)
        patch :update, id: answer, answer: {body: 'NewBody'}, format: :html
      end

      it 'should redirect to question' do
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'when attributes are invalid' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:old_body) { answer.body }
      before do
        login_user(user)
        patch :update, id: answer, answer: {body: nil}
      end

      it 'should not update the answer attributes' do
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'should re render answer edit page' do
        expect(response).to render_template :edit
      end
    end

    it_should_behave_like 'action requiring to own an object' do
      let(:action) { patch :update, id: others_answer, answer: {body: 'NewBody'}, format: :js }
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    it_should_behave_like 'action requiring signed in user' do
      let(:action) { delete :destroy, id: answer }
    end

    it_should_behave_like 'action requiring to own an object' do
      let(:action) {  delete :destroy, id: others_answer }
    end

    context 'when user is signed in' do
      before { login_user(user) }
      it 'should delete the answer' do
        expect do
          delete :destroy, id: answer
        end.to change(question.answers, :count).by(-1)
      end

      it 'should redirect to question' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_answers_path(question)
      end
    end
  end
end
