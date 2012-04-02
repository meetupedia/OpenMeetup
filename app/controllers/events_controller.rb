# -*- encoding : utf-8 -*-

class EventsController < ApplicationController
  load_resource :group
  load_resource :event, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def show
  end

  def new
  end

  def create
    if @event.save
      create_activity @event
      redirect_to @event
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes params[:event]
      redirect_to @event
    else
      render :edit
    end
  end

  def invited
    @event_invitation_targets = @event.event_invitation_targets.order('created_at DESC')
  end

  def users
    @participations = @event.participations.includes(:user).paginate :page => params[:page]
  end
end
