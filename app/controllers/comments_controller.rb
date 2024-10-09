# frozen_string_literal: true

class CommentsController < BaseController
  include Pagy::Backend

  before_action :set_post, only: %i[index create]
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
    @comment = @post.comments.build(create_comment_params)
    @comment.author = User.first # Замените на current_user, когда будет реализована аутентификация

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
    if @comment.replies.empty?
      debugger
      @comment.destroy
      head :no_content
    else
      render json: { error: 'Comment has replies and cannot be deleted' }, status: :conflict
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comments_scope
    @post.comments
         .where(parent_id: params[:parent_id])
         .includes(:author)
         .order(created_at: :desc)
  end

  def create_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def update_comment_params
    params.require(:comment).permit(:content)
  end

  def serialize_comments(comments)
    Panko::ArraySerializer.new(comments, each_serializer: Comments::RootSerializer).as_json
  end

  def serialize_comment(comment)
    Comments::RootSerializer.new.serialize_to_json(comment)
  end
end
