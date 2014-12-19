require 'rails_helper'


RSpec.describe QuestionsController, :type => :controller do

	shared_examples_for 'action requiring signed in user' do
		action
		expect(response).to redirect_to new_user_session_path
	end

	let!(:user){ create(:user) }
	let(:question) { create(:question) }

	describe 'GET #index' do
		let(:questions) { create_list(:question, 2, user: user) }
		before { get :index }

		it 'populates an array of questions' do
			expect(assigns(:questions)).to match_array(questions)
		end 

		it 'renders index view' do
			expect(response).to render_template :index
		end
	end

	describe 'GET #show' do
		before { get :show, id: question }

		it 'renders question answers view' do
			expect(response).to redirect_to question_answers_path(question)
		end
	end

	describe 'GET #new' do
		context 'when user is signed in' do
			before do
				login_user(user)
				get :new
			end

			it 'assigns a new question to @question' do
				expect(assigns(:question)).to be_a_new(Question)
			end

			it 'renders new view' do
				expect(response).to render_template :new
			end
		end
	end

	describe 'GET #edit' do
		before { get :edit, id: question }

		context 'when user is signed in' do
			sign_in_user
			it 'assigns the requested question to @question' do
				expect(assigns(:question)).to eq question
			end

			it 'renders edit view' do
				expect(response).to render_template :edit
			end
		end
	end

	describe 'POST #create' do
		it_should_behave_like 'action requiring signed in user' do
			post :create, question: attributes_for(:question)
		end

		context 'with valid attributes' do

			before { login_user(user) }

			it 'saves the new question to the DB' do
				expect { post :create, question: attributes_for(:question) }.to change(user.questions, :count).by(1)
			end
			
			it 'redirects to show view' do 
				post :create, question: attributes_for(:question)
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			before { login_user(user) }

			it 'does not save the question' do
				expect { post :create, question: attributes_for(:invalid_question) }.not_to change(Question, :count)
			end		

			it 're-renders new view' do
				post :create, question: attributes_for(:invalid_question)
				expect(response).to render_template :new
			end
		end
	end

	describe 'DELETE #destroy' do
		context 'when user is not signed in' do
			it 'redirects to sign in page' do
				post :create, question: attributes_for(:question)
				expect(response).to redirect_to new_user_session_path
			end
		end

		context 'when user is signed in' do
			before { login_user(user) }
			it 'should delete a question' do
				question
				expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
			end

			it 'should redirect to index view' do
				delete :destroy, id: question
				expect(response).to redirect_to questions_path
			end
		end
	end

	describe 'PATCH #update' do
		context 'with valid attributes' do
			it 'assigns the requested question to @question' do
				patch :update, id: question, question: attributes_for(:question)
				expect(assigns(:question)).to eq question
			end

			it 'should update the question attributes' do
				patch :update, id: question, question: {title: 'new title', body: 'new body'}
				question.reload
				expect(question.title).to eq 'new title'
				expect(question.body).to eq 'new body'
			end

			it 'should redirect to show view' do
				patch :update, id: question, question: {title: 'new title', body: 'new body'}
				expect(response).to redirect_to question
			end
		end

		context 'with invalid attributes' do
			before do
				@old_title = question.title
				@old_body = question.body
				patch :update, id: question, question: {title: 'new title', body: nil}
			end

			it 'should not save the question attributes' do
				question.reload
				expect(question.title).to eq @old_title
				expect(question.body).to eq @old_body
			end

			it 'should render edit view' do
				expect(response).to render_template :edit
			end
		end
	end
end
