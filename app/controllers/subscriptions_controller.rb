class SubscriptionsController < ApplicationController
  before_action :load_question, only: [:create]
  respond_to :js

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with(@subscription)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    @subscription.destroy
    respond_with(@subscription)
  end
end
