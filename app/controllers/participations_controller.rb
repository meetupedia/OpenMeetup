class ParticipationsController < ApplicationController
  load_resource :event
  load_resource :participation, :through => :event, :shallow => true
  authorize_resource :except => [:index, :show]

  def create
    unless @event.participation_for(current_user)
      @participation.save
      create_activity @participation
    end
    redirect_to @event
  end

  def destroy
    @participation.destroy
    redirect_to @participation.event
  end

  def set
    create
  end
end
