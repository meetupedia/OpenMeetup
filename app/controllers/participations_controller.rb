# -*- encoding : utf-8 -*-

class ParticipationsController < CommonController
  load_resource :event
  load_resource :participation, :through => :event, :shallow => true
  authorize_resource

  def create
    unless @event.participation_for(current_user)
      @participation.save
      @participation.event.absence_for(current_user).andand.destroy
      run_later do
        @participation.event.group.admins.each do |user|
          EventMailer.participation(current_user, user.email, @event).deliver
        end
      end
      create_activity @participation
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
end
