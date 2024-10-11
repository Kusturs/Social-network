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
    render json: Posts::ShowSerializer.new.serialize_to_json(@post)
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
    @post = Post.includes(comments: :author).find(params[:id])
  end

  def set_current_user_post
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'You could not modify not your posts' }, status: :not_found
  end

  def post_params
    params.require(:post).permit(:content)
  end

  def posts_scope
    Post.includes(:author).order(created_at: :desc)
  end

  def serialize_posts(posts)
    Panko::ArraySerializer.new(posts, each_serializer: Posts::IndexSerializer).to_a
  end

  def serialize_post(post)
    Posts::ShowSerializer.new.serialize_to_json(post)
  end
end
