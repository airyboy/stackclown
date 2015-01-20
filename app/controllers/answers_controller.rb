class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :create]
  before_filter :require_login, only: [:create, :destroy, :update, :edit]
  prepend_before_action :load_answer, only: [:edit, :update, :destroy]
  before_filter :require_owning_object, only: [:edit, :update, :destroy]


  def new
    @answer = @question.build
  end

  def index
    @answers = @question.answers
    @new_answer = Answer.new
    respond_to :html, :json
  end

  def edit
    respond_to :html, :js
  end

  def update
    if @answer.update(answer_params)
      respond_to do |format|
        format.html { redirect_to question_answers_path(@question) }
        format.js
      end
    else
      render :edit, status: 400
    end
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      respond_to do |format|
        format.html { redirect_to question_answers_path(@question) }
        format.js
      end
      publish_answer
    else
      respond_to do |format|
        format.html do
          prepare_data(@question)
          flash[:error] = 'Error'
          render :index
        end
        format.js
      end
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path(@question)
  end

  private

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file])
    end

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.includes(:question).find(params[:id])
      @question = @answer.question
      @object = @answer
    end

    def publish_answer
      pub_json = render_to_string(template: 'answers/show.json.jbuilder', locals: {answer: @answer} )
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: pub_json
    end
end

