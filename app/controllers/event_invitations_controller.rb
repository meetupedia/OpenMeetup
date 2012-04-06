# -*- encoding : utf-8 -*-

class EventInvitationsController < ApplicationController
  load_resource :event
  load_resource :event_invitation, :through => :event, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def new
    @hide_emails = params[:hide_emails]
    render :layout => false if request.xhr?
  end

  def create
    if @event_invitation.save
      if @event_invitation.emails.present?
        @event_invitation.emails.split(/\n/).each do |email|
          event_invitation_target = EventInvitationTarget.find_or_initialize_by_event_id_and_email(@event.id, email)
          save_invitation_target(event_invitation_target)
        end
      else
        @event.participants.each do |participant|
          event_invitation_target = EventInvitationTarget.find_or_initialize_by_event_id_and_invited_user_id(@event.id, participant.id)
          save_invitation_target(event_invitation_target)
        end
      end
      redirect_to @event, :notice => 'Meghívó elküldve.'
    else
      render :new
    end
  end

protected

  def save_invitation_target(event_invitation_target)
    if event_invitation_target.new_record?
      event_invitation_target.event_invitation = @event_invitation
      if event_invitation_target.save
        EventMailer.invitation(current_user, event_invitation_target.email, event_invitation_target.event_invitation.event, event_invitation_target.event_invitation.message).deliver
      end
    end
  end
end
