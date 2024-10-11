# frozen_string_literal: true

class SubscriptionsController < BaseController
  before_action :set_user, only: %i[create destroy]

  def create
    handle_subscription_action(:follow, 'followed')
  end

  def destroy
    handle_subscription_action(:unfollow, 'unfollowed')
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render_not_found unless @user
  end

  def handle_subscription_action(action, past_tense)
    if current_user.send(action, @user)
      render json: { message: "User #{past_tense} successfully", followed_id: @user.id },
             status: action == :follow ? :created : :ok
    else
      render json: { error: "Unable to #{action} user" }, status: :unprocessable_entity
    end
  end

  def render_not_found
    render json: { error: "Couldn't find User with id=#{params[:id]}" }, status: :not_found
  end
end
