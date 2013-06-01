# encoding: UTF-8

class UserSessionsController < CommonController

  def new
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      redirect_back_or_default root_url
    else
      render 'users/new'
    end
  end

  def destroy
    current_user_session.andand.destroy
    redirect_to root_url
  end
end
