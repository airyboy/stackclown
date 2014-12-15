class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def prepare_data(question)
    @new_answer = Answer.new
    @new_comment = Comment.new
    @answers = question.answers
  end
end
