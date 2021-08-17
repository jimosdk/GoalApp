class CommentsController < ApplicationController
  before_action :require_current_user
  before_action :require_author,only:[:destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.commenter_id = current_user.id
    
    flash.now[:errors] = @comment.errors.full_messages unless @comment.save
    
    id = @comment.commentable_id
    type = @comment.commentable_type
    type == 'User' ? redirect_to(user_url(id)) : redirect_to(goal_url(id))
  end

  def destroy
    @comment = Comment.find(params[:id])
    id = @comment.commentable_id
    type = @comment.commentable_type
    @comment.destroy
    type == 'User' ? redirect_to(user_url(id)) : redirect_to(goal_url(id))
  end

  private 

  def comment_params
    params.require(:comment).permit(:body,:commentable_id,:commentable_type)
  end

  def require_author
    @comment = Comment.find_by(id: params[:id])
    if !current_user || (current_user && current_user.id != @comment.commenter_id)
      id = @comment.commentable_id
      type = @comment.commentable_type
      type == 'User' ? redirect_to(user_url(id)) : redirect_to(goal_url(id))
    end
  end
end
