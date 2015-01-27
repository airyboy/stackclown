class QuestionsController < ApplicationController
	before_action :load_question, only: [:show, :edit, :update, :destroy]
	# before_filter :require_login, only: [:new, :create, :edit, :update, :destroy], :except => [:not_authenticated]
	# before_filter :require_owning_object, only: [:edit, :update, :destroy]
	authorize_resource
	after_action :publish_question, only: [:create]

	respond_to :json, only: [:index]
	respond_to :html
	respond_to :js, only: [:edit, :update]

	def index
		@questions = Question.all
		respond_with(@questions)
	end

	def show
		redirect_to question_answers_path(@question)
	end

	def new
		@question = Question.new
		respond_with(@question)
	end

	def edit
	end

	def create 
		@question = current_user.questions.create(question_params)
		flash[:notice] = 'Your question was created' if @question.persisted?
		respond_with(@question)
	end

	def update
		if @question.update(question_params)
			respond_with(@question)
		end
	end

	def destroy
		@question.destroy
		respond_with(@question)
	end

	private

		def load_question
			@question = Question.find(params[:id])
			@object = @question
		end

		def question_params
			params.require(:question).permit(:title, :body, :tags_comma_separated,  attachments_attributes: [:file])
		end

		def publish_question
			if @question.persisted?
				pub_json = render_to_string(template: 'questions/show.json.jbuilder', locals: {question: @question} )
				PrivatePub.publish_to '/questions', question: pub_json
			end
		end
end
