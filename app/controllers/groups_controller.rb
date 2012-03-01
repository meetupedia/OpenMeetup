class GroupsController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show]

  def new
  end

  def create
    if @group.save
      create_activity @group
      redirect_to @group
    else
      render :new
    end
  end

  def show
  end
end
