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
    @new_comment = Comment.new
  end

  def edit
    respond_to do |format|
      format.html { render :edit }
      format.js
    end
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
    else
      prepare_data(@question)
      flash[:error] = 'Error'
      render :index
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path(@question)
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.includes(:question).find(params[:id])
      @question = @answer.question
      @object = @answer
    end
end