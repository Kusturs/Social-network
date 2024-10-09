# frozen_string_literal: true

class UsersController < BaseController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.includes(:posts, :comments)
    render json: Panko::ArraySerializer.new(@users, each_serializer: UserSerializer).to_json
  end

  def show
    render json: UserSerializer.new.serialize_to_json(@user)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new.serialize_to_json(@user), status: :created
    else
      unprocessable_entity(@user)
    end
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new.serialize_to_json(@user)
    else
      unprocessable_entity(@user)
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def me
    @feed = FeedService.new(current_user).call

    render json: FeedSerializer.new.serialize_to_json(feed)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :second_name, :last_name)
  end
end
