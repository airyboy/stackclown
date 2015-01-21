class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create]
  before_action :load_question
  before_filter :require_login, except: [:show]
  before_action :load_comment, only: [:show, :update, :destroy]

  respond_to :json

  def show
    respond_with(@comment)
  end

  def update
    @comment.update(comment_params)
    respond_with @comment do |format|
      format.json { render :show }
    end
  end

  def create
    @comment = @commentable.comments.create(comment_params)
    publish_comment if @comment.persisted?
    respond_with @comment do |format|
      format.json { render :show }
    end
  end

  def destroy
    respond_with(@comment.destroy)
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

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body).merge(user: current_user)
    end

    def publish_comment
      pub_json = render_to_string(template: 'comments/show.json.jbuilder', locals: {comment: @comment} )
      PrivatePub.publish_to "/questions/#{@question.id}/comments", comment: pub_json
    end
end
