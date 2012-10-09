# encoding: UTF-8

class ParticipationsController < CommonController
  load_resource :event
  load_resource :participation, :through => :event, :shallow => true
  authorize_resource

  def create
    unless @event.participation_for(current_user)
      @participation.save
      @participation.event.absence_for(current_user).andand.destroy
      @membership = @participation.event.group.memberships.create :user => current_user unless @participation.event.group.membership_for(current_user)
      run_later do
        if @membership
          create_activity @membership
          @participation.event.group.admins.each do |user|
            GroupMailer.join(@membership, user).deliver if user.email
          end
        end
        @participation.event.group.admins.each do |user|
          EventMailer.participation(@particiation, user).deliver if user.email
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
