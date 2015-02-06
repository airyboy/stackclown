class SearchController < ApplicationController
  def find
    # classes = search_params.except(:q).select{|k,v| v == '1'}.keys.map{|a| a.classify.constantize}
    @result = ThinkingSphinx.search(search_params[:q]).group_by(&:class)
  end

  private
  def search_params
    params.permit(:q, :answer, :question, :comment, :user)
  end
end
