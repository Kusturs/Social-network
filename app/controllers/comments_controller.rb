# frozen_string_literal: true

class CommentsController < BaseController
  before_action :set_comment, only: %i[show update destroy]

  def index
    @pagy, @comments = pagy(comments_scope)

    render json: {
      comments: serialize_comments(@comments),
      pagination: pagy_metadata(@pagy)
    }
  end

  def show
    render json: serialize_comment(@comment)
  end

  def create
    parent_id = params[:comment][:parent_id]
    content = params[:comment][:content]
    post_id = params[:post_id]

    if parent_id.present?
      parent_comment = Comment.find(parent_id)
      @comment = parent_comment.replies.build(post_id: post_id, content: content)
    else
      post = Post.find(post_id)
      @comment = post.comments.build(create_comment_params)
    end

    @comment.author = current_user

    if @comment.save
      render json: serialize_comment(@comment), status: :created
    else
      unprocessable_entity(@comment)
    end
  end

  def update
    if @comment.update(update_comment_params)
      render json: serialize_comment(@comment)
    else
      unprocessable_entity(@comment)
    end
  end

  def destroy
    Comment.delete_with_replies(@comment.id)
    head :no_content
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comments_scope
    Post.includes(:author).find(params[:post_id]).comments
        .where(parent_id: params[:parent_id])
        .order(created_at: :desc)
  end

  def create_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def update_comment_params
    params.require(:comment).permit(:content)
  end

  def serialize_comments(comments)
    Panko::ArraySerializer.new(comments, each_serializer: Comments::RootSerializer).to_a
  end

  def serialize_comment(comment)
    Comments::RootSerializer.new.serialize_to_json(comment)
  end
end
