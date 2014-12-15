class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create]

  def create
    comment = @commentable.comments.build(comment_params)

    if comment.save
      redirect_to question_answers_path(@question)
    else
      prepare_data(@question)
      flash[:error] = 'Error'
      render 'answers/index'
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    @commentable = comment.commentable
    load_question
    comment.destroy
    redirect_to question_answers_path(@question)
  end

  private
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @commentable = $1.classify.constantize.find(value)
        end
      end
      load_question
    end

    def load_question
      if @commentable.instance_of?(Question)
        @question = @commentable
      elsif @commentable.instance_of?(Answer)
        @question = @commentable.question
      end
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
