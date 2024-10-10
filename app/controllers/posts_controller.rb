# frozen_string_literal: true

class PostsController < BaseController
  before_action :set_post, only: %i[show]
  before_action :set_current_user_post, only: %i[update destroy]

  def index
    @pagy, @posts = pagy(posts_scope)

    render json: {
      posts: serialize_posts(@posts),
      pagination: pagy_metadata(@pagy)
    }
  end

  def show
    render json: serialize_post(@post)
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: serialize_post(@post), status: :created
    else
      unprocessable_entity(@post)
    end
  end

  def update
    if @post.update(post_params)
      render json: serialize_post(@post)
    else
      unprocessable_entity(@post)
    end
  end

  def destroy
    @post.comments.destroy_all
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_current_user_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def posts_scope
    Post.includes(:author, :comments).order(created_at: :desc)
  end

  def serialize_posts(posts)
    Panko::ArraySerializer.new(posts, each_serializer: PostSerializer).to_a
  end

  def serialize_post(post)
    PostSerializer.new.serialize_to_json(post)
  end
end
