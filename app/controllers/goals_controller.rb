class GoalsController < ApplicationController
  before_action :require_current_user,except:[:show]
  before_action :private?,only: [:show]
  before_action :require_author , only: [:complete]
  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
    render :edit
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def show
    @goal = Goal.find_by(id: params[:id])
    render :show
  end

  def complete 
    @goal = Goal.find_by(id: params[:id])
    @goal.toggle(:completed)
    @goal.save
    redirect_to goal_url(@goal)
  end

  private 

  def goal_params
    params.require(:goal).permit(:title,:description,:private,:completed)
  end

  def private?
    @goal = Goal.find_by(id: params[:id])
    redirect_to user_url(@goal.user_id) if @goal.private && !current_user || (current_user && current_user.id != @goal.user_id)
  end

  def require_author
    @goal = Goal.find_by(id: params[:id]) 
    redirect_to goal_url(@goal) if !current_user || (current_user && current_user.id != @goal.user_id)
  end
end
