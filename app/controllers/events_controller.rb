class EventsController < ApplicationController
  load_resource :group
  load_resource :event, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show]

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

  def show
  end
end
