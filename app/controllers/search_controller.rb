class SearchController < ApplicationController
  def find
    classes = search_params.except(:q).except(:page).select{|k,v| v == '1'}.keys.map{|a| a.classify.constantize}
    @form_state = search_params
    @search_result = ThinkingSphinx.search(search_params[:q], classes: classes, page: search_params[:page])
    @result = @search_result.group_by(&:class)
  end

  private
  def search_params
    params.permit(:q, :answer, :question, :comment, :user, :page)
  end
end
