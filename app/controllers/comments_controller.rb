class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create]
  before_filter :require_login

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      respond_to do |format|
        format.html { redirect_to question_answers_path(@question) }
        format.json { render json: comment }
      end
    else
      respond_to do |format|
        format.html do
          prepare_data(@question)
          flash[:error] = 'Error'
          render 'answers/index'
        end
        format.json { render json: comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    @commentable = comment.commentable
    load_question
    comment.destroy
    respond_to do |format|
      format.html { redirect_to question_answers_path(@question) }
      format.json { render text: 'ok' }
    end
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
