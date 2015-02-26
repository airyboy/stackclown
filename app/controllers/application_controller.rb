class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :vary_accept

  protected

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      signedin_user_error(exception.message)
    else
      guest_user_error
    end
  end

    def guest_user_error
      redirect_to login_path, alert: 'Please login first.'
    end

    def signedin_user_error(message)
      redirect_to root_url, alert: message, status: :forbidden
    end

    def not_authenticated
      redirect_to new_user_session_path, :alert => 'Please login first.'
    end

    def prepare_data(question)
      @new_answer = Answer.new
      @new_comment = Comment.new
      @answers = question.answers
    end

    def require_owning_object
      return head :unauthorized unless @object.user == current_user
    end

    def vary_accept
      response.headers['Vary'] = 'Accept'
    end

    def load_question
      @question = Question.find(params[:question_id])
    end
end
