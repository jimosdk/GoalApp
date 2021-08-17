class GoalCommentsController < ApplicationController
  before_action :require_current_user
  before_action :require_author,only: [:destroy]
  

  def create
    @comment = GoalComment.new(comment_params)
    @comment.commenter_id = current_user.id

    if @comment.save
      redirect_to goal_url(params[:goal_comment][:goal_id])
    else 
      flash.now[:errors] = @comment.errors.full_messages
      redirect_to goal_url(params[:goal_comment][:goal_id])
    end
  end

  def destroy
    @comment = GoalComment.find(params[:id])
    goal_id = @comment.goal_id
    @comment.destroy
    redirect_to goal_url(goal_id)
  end

  private 

  def comment_params
    params.require(:goal_comment).permit(:body,:goal_id)
  end

  def require_author
    @comment = GoalComment.find_by(id: params[:id])
    redirect_to goal_url(@comment.goal_id) if !current_user || (current_user && current_user.id != @comment.commenter_id)
  end
end
