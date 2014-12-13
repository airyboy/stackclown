class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create, :destroy]
  before_action :load_question

  def create
    comment = @commentable.comments.build(comment_params)

    if comment.save
      redirect_to question_answers_path(@question)
    else
      flash[:error] = 'Error'
      render 'answers/index'
    end
  end

  def destroy
    @commentable.comments.find(params[:id]).destroy
    redirect_to question_answers_path(@question)
  end

  private
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @commentable = $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def load_question
      @question = Question.find(params[:question_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
