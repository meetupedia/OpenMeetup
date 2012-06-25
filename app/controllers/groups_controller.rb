# -*- encoding : utf-8 -*-

class GroupsController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show, :events, :images, :members]

  def show
    @title = @group.name
    @static_follow = true
  end

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @group.save
      current_organization.groups << @group if current_organization
      create_activity @group
      redirect_to @group
    else
      render :new
    end
  end

  def edit
    render :layout => false if request.xhr?
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
    redirect_to dashboard_user_path(current_user)
  end

  def events
    @events = @group.events.order('start_time DESC').paginate :page => params[:page]
  end

  def images
  end

  def invited
    @group_invitation_targets = @group.group_invitation_targets.order('created_at DESC')
  end

  def members
    @memberships = @group.memberships.includes(:user).paginate :page => params[:page]
  end

  def waves
    @waves = @group.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end
end
