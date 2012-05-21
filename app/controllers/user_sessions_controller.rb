# encoding: UTF-8

class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy

  def new
    @sidebar = false
  end

  def create
    @user_session = UserSession.new params[:user_session]
    if @user_session.save
      unless @user_session.record.email_confirmed?
        run_later { UserMailer.confirmation(@user_session.record).deliver }
        flash[:alert] = "A regisztráció nem lett megerősítve! Küldtünk egy e-mailt #{@user_session.record.email.az} címre a tennivalókkal."
      end
      @user_session.record.update_attribute :is_deleted, false if @user_session.record.is_deleted?
      redirect_back_or_default user_url(@user_session.record)
    else
      flash.now[:alert] = 'Érvénytelen bejelentkezési adatok!'
      @sidebar = false
      render :new
    end
  end

  def destroy
    current_user_session.andand.destroy
    redirect_back_or_default new_user_session_url
  end
end
