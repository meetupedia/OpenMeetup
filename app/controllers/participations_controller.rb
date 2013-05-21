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
      run_later do
        @participation.event.group.admins.each do |user|
          begin
            EventMailer.participation(@participation, user).deliver
          rescue
          end
        end
      end
    end
    if @event.questions.size > 0
      redirect_to edit_participation_path(@participation)
    else
      redirect_to @event
    end
  end

  def edit
    @participation.event.questions.each do |question|
      @participation.answers.build :question => question unless @participation.answers.where(:question_id => question.id).first
    end
  end

  def update
    @participation.update_attributes params[:participation]
    redirect_to @participation.event
  end

  def destroy
    @participation.destroy
    redirect_to @participation.event
  end

  def checkin
    @participation.update_attributes :is_checkined => true
    redirect_to actual_event_path(@participation.event)
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
