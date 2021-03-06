require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do

	let!(:user){ create(:user) }
	let!(:other_user){ create(:user) }
	let(:question) { create(:question, user: user) }
	let(:other_question) { create(:question, user: other_user) }

	describe 'GET #index' do
		let(:questions) { create_list(:question, 2, user: user) }
		before { get :index }

		it 'populates an array of questions' do
			expect(assigns(:questions)).to match_array(questions)
		end 

		it 'renders index view' do
			expect(response).to render_template :index
		end

		context 'when json' do
			render_views
			it 'should render json' do
				get :index, format: :json
				parsed_body = JSON.parse(response.body)
				expect(parsed_body).not_to be_nil
			end
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

		it_should_behave_like 'action requiring signed in user' do
			let(:action) { get :edit, id: question }
		end

		context 'when user is signed in' do
			before do
				login_user(user)
				get :edit, id: question
			end

			it 'assigns the requested question to @question' do
				expect(assigns(:question)).to eq question
			end

			it 'renders edit view' do
				expect(response).to render_template :edit
			end

			it_should_behave_like 'action requiring to own an object' do
				let(:action) { get :edit, id: other_question }
			end
		end
	end

	describe 'POST #create' do
		before { login_user(user) }

		context 'with valid attributes' do
			it 'saves the new question to the DB' do
				expect { post :create, question: attributes_for(:question) }.to change(user.questions, :count).by(1)
      end

      it 'publishes question to subscribers' do
        expect(PrivatePub).to receive(:publish_to).with('/questions', anything())
        post :create, question: attributes_for(:question)
      end
			
			it 'redirects to show view' do 
				post :create, question: attributes_for(:question)
				expect(response).to redirect_to question_path(assigns(:question))
			end

			it 'assigns right tags' do
				expect { post :create, question: attributes_for(:question) }.to change(Tag, :count).by(2)
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
		it_should_behave_like 'action requiring signed in user' do
			let(:action) { delete :destroy, id: question }
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

			it_should_behave_like 'action requiring to own an object' do
				let(:action) { delete :destroy, id: other_question }
			end
		end
	end

	describe 'PATCH #update' do

		it_should_behave_like 'action requiring signed in user' do
			let(:action) { patch :update, id: question, question: attributes_for(:question) }
		end

		context 'with valid attributes' do
			before { login_user(user) }
			it 'assigns the requested question to @question' do
				patch :update, id: question, question: attributes_for(:question)
				expect(assigns(:question)).to eq question
			end

			it 'should update the question attributes' do
				patch :update, id: question, question: {title: 'new title', body: 'new body', tags_comma_separated: 'first-tag,second-tag'}
				question.reload
				expect(question.title).to eq 'new title'
				expect(question.body).to eq 'new body'
			end

			it_should_behave_like 'action requiring to own an object' do
				let(:action) { patch :update, id: other_question, question: {title: 'new title', body: 'new body'} }
			end
		end

		context 'with invalid attributes' do
			before do
				login_user(user)
				@old_title = question.title
				@old_body = question.body
				patch :update, id: question, question: {title: 'new title', body: nil}, format: :js
			end

			it 'should not save the question attributes' do
				question.reload
				expect(question.title).to eq @old_title
				expect(question.body).to eq @old_body
			end

			it 'should render edit view' do
				expect(response).to render_template :update
			end
		end
  end

  describe 'PATCH #upvote' do
    it_behaves_like 'voting action' do
      let!(:question) { create(:question, user: other_user) }
      let!(:my_question) { create(:question, user: user) }
      let(:action) { patch :upvote, id: question.id, format: :json }
      let(:my_action) { patch :upvote, id: my_question.id, format: :json }
    end
  end

  describe 'PATCH #downvote' do
    it_behaves_like 'voting action' do
      let!(:question) { create(:question, user: other_user) }
      let!(:my_question) { create(:question, user: user) }
      let(:action) { patch :downvote, id: question.id, format: :json }
      let(:my_action) { patch :downvote, id: my_question.id, format: :json }
    end
  end
end
