class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :create, :update]
  before_filter :require_login, only: [:create, :destroy, :update]

  def new
    @answer = @question.build
  end

  def index
    @answers = @question.answers
    @new_answer = Answer.new
    @new_comment = Comment.new
  end

  def update
    @answer = @question.answers.find(params[:id])
    if @answer.update(answer_params)
      redirect_to question_answers_path(@question)
    else
      render :edit
    end
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_answers_path(@question)
    else
      prepare_data(@question)
      flash[:error] = 'Error'
      render :index
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
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
end