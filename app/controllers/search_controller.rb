class SearchController < ApplicationController
  skip_authorization_check

  def find
    classes = search_params.except(:q).except(:page).select{|k,v| v == '1'}.keys.map{|a| a.classify.constantize}
    @words = search_params[:q].gsub(/[:;,]/, ' ').split
    @form_state = search_params
    @result = {}
    @search_result = []
    unless search_params[:q].blank?
      @search_result = ThinkingSphinx.search(search_params[:q], classes: classes, page: search_params[:page])
      @result = @search_result.group_by(&:class)
    end
  end

  private
  def search_params
    params.permit(:q, :answer, :question, :comment, :user, :page)
  end
end
