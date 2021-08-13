class SessionsController < ApplicationController
  before_action :require_no_current_user, except: [:destroy]
  before_action :require_current_user,only: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:session][:name],
                                     params[:session][:password])
    if @user
      log_in!
      redirect_to user_url(@user)
    else  
      flash.now[:errors] = ['Invalid credentials']
      render :new
    end
  end

  def destroy
    log_out!
    render :new
  end
end
