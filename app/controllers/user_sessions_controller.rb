# encoding: UTF-8

class UserSessionsController < ApplicationController

  def new
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      redirect_back_or_default discovery_url
    else
      render :new
    end
  end

  def destroy
    current_user_session.andand.destroy
    redirect_to root_url
  end
end
