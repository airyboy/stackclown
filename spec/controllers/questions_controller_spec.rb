require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
	
	let(:question) { create(:question) }

	describe 'GET #index' do
		let(:questions) { create_list(:question, 2) }
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
		before { get :new }

		it 'assigns a new question to @question' do
			expect(assigns(:question)).to be_a_new(Question)
		end

		it 'renders new view' do	
			expect(response).to render_template :new
		end
	end

	describe 'GET #edit' do
		before { get :edit, id: question }

		it 'assigns the requested question to @question' do
			expect(assigns(:question)).to eq question
		end

		it 'renders edit view' do
			expect(response).to render_template :edit
		end
	end

	describe 'POST #create' do
		context 'with valid attributes' do
			it 'saves the new question to the DB' do
				expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
			end
			
			it 'redirects to show view' do 
				post :create, question: attributes_for(:question)
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
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
		it 'should delete a question' do
			question
			expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
		end

		it 'should redirect to index view' do
			delete :destroy, id: question
			expect(response).to redirect_to questions_path
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
