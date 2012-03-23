# -*- encoding : utf-8 -*-

class FollowsController < ApplicationController
  load_resource :group
  load_resource :follow, :through => :group, :shallow => true
  authorize_resource

  def create
    unless @group.follow_for(current_user)
      @follow.save
      create_activity @follow
    end
    redirect_to @group unless request.xhr?
  end

  def destroy
    @follow.destroy
    if request.xhr?
      render :create
    else
      redirect_to @follow.group
    end
  end

  def set
    create
  end
end
