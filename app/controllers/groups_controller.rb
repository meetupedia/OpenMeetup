# -*- encoding : utf-8 -*-

class GroupsController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show, :users]

  def show
  end

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @group.save
      create_activity @group
      redirect_to @group
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update_attributes params[:group]
      redirect_to @group
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to root_url
  end

  def users
    @memberships = @group.memberships.includes(:user).paginate :page => params[:page]
  end
end
