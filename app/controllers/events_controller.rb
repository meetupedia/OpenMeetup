# encoding: UTF-8

class EventsController < CommonController
  load_resource :group
  load_resource :event, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show, :actual, :images, :map, :users]

  def show
    events_show
  end

  def new
    @event.start_time = Time.zone.now.beginning_of_day + 19.hours
    @event.end_time = Time.zone.now.beginning_of_day + 22.hours
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

  def destroy
    @event.destroy
    redirect_to @event.group, :notice => 'Esemény törölve.'
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
end
