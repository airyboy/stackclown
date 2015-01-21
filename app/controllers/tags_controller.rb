class TagsController < ApplicationController
  respond_to :html

  def index
    respond_with(@tags = Tag.all)
  end

  def show
    respond_with(@tag = Tag.find(params[:id]))
  end
end
