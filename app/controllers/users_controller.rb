# frozen_string_literal: true

class UsersController < BaseController
  before_action :set_user, only: %i[show]

  def index
    @pagy, @users = pagy(User.all)

    render json: {
      users: serialize_users(@users),
      pagination: pagy_metadata(@pagy)
    }
  end

  def show
    render json: serialize_user(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :second_name, :last_name)
  end

  def serialize_users(users)
    Panko::ArraySerializer.new(users, each_serializer: Users::IndexSerializer).to_a
  end

  def serialize_user(user)
    Users::ShowSerializer.new.serialize_to_json(user)
  end
end
