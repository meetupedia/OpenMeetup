# encoding: UTF-8

class ParticipationsController < CommonController
  load_resource :event
  load_resource :participation, :through => :event, :shallow => true
  authorize_resource :except => [:set]
  before_filter :set_add_participation_for, :only => [:set]
  before_filter :authenticate, :only => [:set]

  cache_sweeper :participation_sweeper, :only => [:create]

  def create
    unless @event.participation_for(current_user)
      @group = @event.group
      @participation.save
      cookies.delete :add_participation_for
    end
    redirect_to @event
  end

  def destroy
    @participation.destroy
    redirect_to @participation.event
  end

  def set
    @participation = @event.participations.build
    create
  end

protected

  def set_add_participation_for
    cookies[:add_participation_for] = @event.id
  end
end
