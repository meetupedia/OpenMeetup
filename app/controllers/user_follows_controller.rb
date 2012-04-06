# -*- encoding : utf-8 -*-

class UserFollowsController < ApplicationController
  load_resource :user
  load_resource :user_follow, :through => :user, :shallow => true, :except => [:create]
  authorize_resource

  def create
    @user_follow = UserFollow.new :followed_user_id => @user.id
    unless @user.user_follow_for(current_user)
      @user_follow.save
      create_activity @user_follow
    end
    redirect_to @user unless request.xhr?
  end

  def destroy
    @user_follow.destroy
    if request.xhr?
      render :create
    else
      redirect_to @user_follow.followed_user
    end
  end
end
