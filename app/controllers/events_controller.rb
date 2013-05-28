# encoding: UTF-8

class EventsController < CommonController
  load_resource :group
  load_resource :event, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show, :actual, :images, :map, :users]

  def show
    events_show
    @title = @event.name
  end

  def new
    @event.start_time = Time.now.beginning_of_day + 19.hours
    @event.end_time = Time.now.beginning_of_day + 22.hours
  end

  def create
    if @event.save
      create_activity @event
      counter = 0
      recipients = @event.group.admins
      recipients += @event.group.members if @event.invite_all_group_members == '1'
      recipients -= [@event.user]
      recipients.each do |user|
        event_invitation = EventInvitation.find_or_create_by_event_id_and_invited_user_id(@event.id, user.id)
        begin
          EventInvitationMailer.invitation(event_invitation).deliver
          counter += 1
        rescue
        end
      end
      notice = if counter == 0
        trfn('Event created.')
      elsif counter == 1
        trfn('Event created and') + ' 1 ' + trfn('invitation sent.')
      else
        trfn('Event created and') + " #{counter} " + trfn('invitations sent.')
      end
      redirect_to @event, :notice => notice.html_safe
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes params[:event]
      redirect_to @event, :notice => trfn('Event updated.')
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to @event.group, :notice => trfn('Event deleted.')
  end

  def actual
  end

  def images
  end

  def invited
    @event_invitations = @event.event_invitations.order('created_at DESC').page(params[:page])
  end

  def map
  end

  def participations
    @participations = @event.participations.includes(:user, {:answers => :question})
  end

  def reviews
    @reviews = @event.reviews.order('created_at DESC')
  end

  def users
    @participations = @event.participations.includes(:user).paginate :page => params[:page]
  end

  def users_with_emails
    @users = @event.participants.order('name ASC')
  end
end
