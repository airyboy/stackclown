class AnswersController < ApplicationController
  before_action :load_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      flash[:error] = 'Error'
      render 'questions/show'
    end
  end

  def destroy
    @answer = @question.answers.find_by(id: params[:id])
    @answer.destroy!
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
