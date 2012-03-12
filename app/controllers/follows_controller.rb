class FollowsController < ApplicationController
  load_resource :group
  load_resource :follow, :through => :group, :shallow => true
  authorize_resource

  def create
    unless @group.follow_for(current_user)
      @follow.save
      create_activity @follow
    end
    redirect_to @group
  end

  def destroy
    @follow.destroy
    redirect_to @follow.group
  end

  def set
    create
  end
end
