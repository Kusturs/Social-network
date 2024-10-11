# frozen_string_literal: true

class UsersController < BaseController
  before_action :set_user, only: %i[show update]

  def index
    @pagy, @users = pagy(users_scope)

    render json: {
      users: serialize_users(@users),
      pagination: pagy_metadata(@pagy)
    }
  end

  def show
    render json: serialize_user(@user)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: serialize_user(@user), status: :created
    else
      unprocessable_entity(@user)
    end
  end

  def update
    if @user.update(user_params)
      render json: serialize_user(@user)
    else
      unprocessable_entity(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :second_name, :last_name)
  end

  def users_scope
    User.includes(:posts, :comments)
  end

  def serialize_users(users)
    Panko::ArraySerializer.new(users, each_serializer: UserSerializer).to_a
  end

  def serialize_user(user)
    UserSerializer.new.serialize_to_json(user)
  end
end
