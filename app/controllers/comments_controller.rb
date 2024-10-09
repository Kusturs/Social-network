# frozen_string_literal: true

class CommentsController < BaseController
  before_action :set_comment, only: %i[show update destroy]
  before_action :set_post, only: %i[index create]

  def index
    @comments = @post.comments.includes(:author, :post)
    render json: Panko::ArraySerializer.new(@comments, each_serializer: CommentSerializer).to_json
  end

  def show
    render json: CommentSerializer.new.serialize_to_json(@comment)
  end

  def create
    @comment = @post.comments.new(create_comment_params)
    # @comment.author = current_user

    if @comment.save
      render json: CommentSerializer.new.serialize_to_json(@comment), status: :created
    else
      unprocessable_entity(@comment)
    end
  end

  def update
    if @comment.update(update_comment_params)
      render json: CommentSerializer.new.serialize_to_json(@comment)
    else
      unprocessable_entity(@comment)
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def create_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def update_comment_params
    params.require(:comment).permit(:content)
  end
end
