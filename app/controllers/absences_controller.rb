# -*- encoding : utf-8 -*-

class AbsencesController < ApplicationController
  load_resource :event
  load_resource :absence, :through => :event, :shallow => true
  authorize_resource

  def create
    unless @event.absence_for(current_user)
      @absence.save
      @absence.event.participation_for(current_user).andand.destroy
    end
    redirect_to @event
  end

  def destroy
    @absence.destroy
    redirect_to @absence.event
  end

  def set
    create
  end
end
