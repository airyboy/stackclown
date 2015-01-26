class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :create]
  # before_filter :require_login, only: [:create, :destroy, :update, :edit]
  prepend_before_action :load_answer, only: [:edit, :update, :destroy]
  # before_filter :require_owning_object, only: [:edit, :update, :destroy]

  authorize_resource

  respond_to :json, only: [:index]
  respond_to :js, only: [:create, :edit, :update]
  respond_to :html, only: [:index, :destroy]

  def new
    @answer = @question.build
  end

  def index
    @answers = @question.answers
    respond_with(@answers)
  end

  def edit
    respond_to :html, :js
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def create
    @answer = @question.answers.create(answer_params)
    publish_answer if @answer.persisted?
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with(@question, location: question_answers_url(@question))
  end

  private

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file]).merge(user: current_user)
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

