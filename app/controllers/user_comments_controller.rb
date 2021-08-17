class UserCommentsController < ApplicationController
  before_action :require_current_user
  before_action :require_author,only: [:destroy]
  
  def create
    @comment = UserComment.new(comment_params)
    @comment.commenter_id = current_user.id

    if @comment.save
      redirect_to user_url(params[:user_comment][:commented_id])
    else 
      flash.now[:errors] = @comment.errors.full_messages
      redirect_to user_url(params[:user_comment][:commented_id])
    end
  end

  def destroy
    @comment = UserComment.find(params[:id])
    commented_id = @comment.commented_id
    @comment.destroy
    redirect_to user_url(commented_id)
  end

  private 

  def comment_params
    params.require(:user_comment).permit(:body,:commented_id)
  end

  def require_author
    @comment = UserComment.find_by(id: params[:id])
    redirect_to user_url(@comment.commented_id) if !current_user || (current_user && current_user.id != @comment.commenter_id)
  end
end
