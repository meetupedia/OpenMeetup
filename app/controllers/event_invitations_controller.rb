# -*- encoding : utf-8 -*-

class EventInvitationsController < ApplicationController
  load_resource :event
  load_resource :event_invitation, :through => :event, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @event_invitation.save
      @event_invitation.emails.split(/\n/).each do |email|
        event_invitation_target = EventInvitationTarget.find_or_initialize_by_event_id_and_email(@event.id, email)
        if event_invitation_target.new_record?
          event_invitation_target.event_invitation = @event_invitation
          if event_invitation_target.save
            EventMailer.invitation(event_invitation_target.email, event_invitation_target.event_invitation.event, event_invitation_target.event_invitation.message).deliver
          end
        end
      end
      redirect_to @event, :notice => 'Meghívó elküldve.'
    else
      render :new
    end
  end
end
