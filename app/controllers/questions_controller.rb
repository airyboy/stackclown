class QuestionsController < ApplicationController
	before_action :load_question, only: [:show, :edit, :update, :destroy]
	before_filter :require_login, only: [:new, :create, :update, :destroy], :except => [:not_authenticated]

	def index
		@questions = Question.all
	end

	def show
		redirect_to question_answers_path(@question)
	end

	def new
		@question = Question.new
	end

	def edit
	end

	def create 
		@question = current_user.questions.build(question_params)

		if @question.save
			flash[:notice] = 'Your question was created'
			redirect_to @question
		else
			render :new 
		end
	end

	def update
		if @question.update(question_params)
			redirect_to @question
		else
			render :edit
		end
	end

	def destroy
		@question.destroy
		redirect_to questions_path
	end

	private

		def load_question
			@question = Question.find(params[:id])
		end

		def question_params
			params.require(:question).permit(:title, :body)
		end
end
