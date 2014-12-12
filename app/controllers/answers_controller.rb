class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :create, :destroy]

  def new
    @answer = @question.build
  end

  def index
    @answers = @question.answers
    @new_answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to question_answers_path(@question)
    else
      flash[:error] = 'Error'
      render :index
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    redirect_to question_path(@question)
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end

    def load_question
      @question = Question.find_by(id: params[:question_id])
    end
end