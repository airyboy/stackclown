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
      let(:action) {  post :create, question_id: question, answer: attributes_for(:answer), format: :js }
    end

    context 'when attributes are valid' do
      before { login_user(user) }
      it 'should save the new answer to the DB' do
        expect do
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'publishes an answer to subscribers' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", anything())
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
      end
    end

    context 'when attributes are invalid' do
      before { login_user(user) }
      it 'should not save the answer to the DB' do
        expect do
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        end.not_to change(question.answers, :count)
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

    context 'when attributes are invalid' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:old_body) { answer.body }
      before do
        login_user(user)
        patch :update, id: answer, answer: {body: nil}, format: :js
      end

      it 'should not update the answer attributes' do
        answer.reload
        expect(answer.body).to eq old_body
      end

      it 'should re render answer edit page' do
        expect(response).to render_template :update
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

  describe 'PATCH #mark' do
    let!(:answers) { create_list(:answer, 2, question: question) }

    context 'when user is signed in' do
      before { login_user(user) }

      it 'should mark off the answer' do
        answer = answers.first
        patch :mark, id: answer.id, format: :json
        expect(answers.first.reload).to be_best
      end
    end
  end

end
