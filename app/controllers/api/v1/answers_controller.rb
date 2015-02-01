class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]

  def index
    respond_with @question.answers
  end

  def show
    respond_with Answer.find(params[:id]), serializer: SingleAnswerSerializer, root: 'answer'
  end

  def create
    answer = @question.answers.create(answer_params)
    respond_with answer
  end

  private
  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_resource_owner)
  end
end