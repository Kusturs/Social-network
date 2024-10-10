# frozen_string_literal: true

class SubscriptionsController < BaseController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]

  def create
    if current_user.follow(@user)
      render json: { message: 'User followed successfully', followed_id: @user.id }, status: :created
    else
      unprocessable_entity(@subscription)
    end
  end

  def destroy
    if current_user.unfollow(@user)
      render json: { message: 'User unfollowed successfully', followed_id: @user.id }, status: :ok
    else
      unprocessable_entity(@subscription)
    end
  end

  def set_user
    @user = User.find(params[:followed_id])
  end
end
