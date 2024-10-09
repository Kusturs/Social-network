# frozen_string_literal: true

class SubscriptionsController < BaseController
  # before_action :authenticate_user!
  before_action :set_user, only: [:create]
  before_action :set_subscription, only: [:destroy]

  def create
    # @subscription = current_user.followed_subscriptions.new(followed: @user)
    # @subscription = Subscription.new(follower: current_user, followed: @user)

    if @subscription.save
      render json: SubscriptionSerializer.new.serialize_to_json(@subscription), status: :created
    else
      unprocessable_entity(@subscription)
    end
  end

  def destroy
    @subscription.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:followed_id])
  end

  # def set_subscription
  #   @subscription = current_user.followed_subscriptions.find(params[:id])
  # end
end
