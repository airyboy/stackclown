module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:upvote, :downvote]
  end

  def upvote
    @resource.upvote unless @resource.user == current_user
    render json: { total: @resource.total_points, resource: @resource.class.to_s.downcase, id: @resource.id }
  end

  def downvote
    @resource.downvote unless @resource.user == current_user
    render json: { total: @resource.total_points, resource: @resource.class.to_s.downcase, id: @resource.id }
  end
end