class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with(Question.find(params[:id]), serializer: SingleQuestionSerializer, root: 'question')
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    respond_with @question
  end

  private
  def question_params
    params.require(:question).permit(:title, :body, :tags_comma_separated)
  end
end