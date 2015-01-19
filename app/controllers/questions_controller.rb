class QuestionsController < ApplicationController
	prepend_before_action :load_question, only: [:show, :edit, :update, :destroy]
	before_filter :require_login, only: [:new, :create, :edit, :update, :destroy], :except => [:not_authenticated]
	before_filter :require_owning_object, only: [:edit, :update, :destroy]

	respond_to :html
	respond_to :js, only: [:index, :edit, :update]

	def index
		@questions = Question.all
		respond_to do |format|
			format.html
			format.json
		end
	end

	def show
		redirect_to question_answers_path(@question)
	end

	def new
		@question = Question.new
		@question.attachments.build
	end

	def edit
		@question.tags_comma_separated = @question.tag_list
		respond_to do |format|
			format.html
			format.js
		end
	end

	def create 
		@question = current_user.questions.build(question_params)
		if @question.save
			@question.make_tags
			pub_json = render_to_string(template: 'questions/show.json.jbuilder', locals: {question: @question} )
			PrivatePub.publish_to '/questions', question: pub_json
			flash[:notice] = 'Your question was created'
			redirect_to @question
		else
			render :new 
		end
	end

	def update
		if @question.update(question_params)
			@question.make_tags
			respond_to do |format|
				format.html { redirect_to question_answers_path(@question) }
				format.js
			end
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
			@object = @question
		end

		def question_params
			params.require(:question).permit(:title, :body, :tags_comma_separated,  attachments_attributes: [:file])
		end
end
