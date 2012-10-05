# encoding: UTF-8

class EventInvitationsController < CommonController
  load_resource :event
  load_resource :event_invitation, :through => :event, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def new
    @users = if params[:invite_members]
      @event.group.members - [current_user]
    else
      []
    end
  end

  def create
    unless @event_invitation.ids.blank?
      @event_invitation.ids.split(',').each do |id|
        if user = User.find_by_id(id)
          event_invitation = EventInvitation.find_or_initialize_by_event_id_and_invited_user_id(@event.id, user.id)
          event_invitation.email ||= user.email
        else
          event_invitation = EventInvitation.find_or_initialize_by_event_id_and_email(@event.id, id)
        end
        if event_invitation.new_record?
          event_invitation.message = @event_invitation.message
          if event_invitation.save
            EventMailer.invitation(event_invitation).deliver
          end
        end
      end
      redirect_to invited_event_path(@event), :notice => 'Meghívó elküldve.'
    end
  end
end
