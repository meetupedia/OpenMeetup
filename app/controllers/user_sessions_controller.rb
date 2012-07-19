# encoding: UTF-8

class UserSessionsController < ApplicationController

  def new
    session[:return_to] = params[:return_to]
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      redirect_to session[:return_to] || discovery_url
    else
      render :new
    end
  end

  def destroy
    current_user_session.andand.destroy
    redirect_to root_url
  end
end
