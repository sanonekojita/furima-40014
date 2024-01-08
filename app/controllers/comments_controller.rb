class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @item = Item.find(params[:item_id])
    return unless @comment.save

    CommentChannel.broadcast_to @item, { comment: @comment, created_at: @comment.created_at, user: @comment.user }
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :created_at).merge(user_id: current_user.id, item_id: params[:item_id])
  end
end
