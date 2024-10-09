# frozen_string_literal: true

class PostsController < BaseController
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.includes(:author, :comments)
    render json: Panko::ArraySerializer.new(@posts, each_serializer: PostSerializer).to_json
  end

  def show
    render json: PostSerializer.new.serialize_to_json(@post)
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: PostSerializer.new.serialize_to_json(@post), status: :created
    else
      unprocessable_entity(@post)
    end
  end

  def update
    if @post.update(post_params)
      render json: PostSerializer.new.serialize_to_json(@post)
    else
      unprocessable_entity(@post)
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :author_id)
  end
end
