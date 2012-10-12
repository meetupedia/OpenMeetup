class ParticipationSweeper < ActionController::Caching::Sweeper
  observe Participation

  def after_create(participation)
    Activity.create_from participation, current_user, participation.event.group, participation.event
    participation.event.absence_for(current_user).andand.destroy
    membership = participation.event.group.memberships.create :user => current_user unless participation.event.group.membership_for(current_user)
    run_later do
      participation.event.group.admins.each do |user|
        EventMailer.participation(particiation, user).deliver if user.email
      end
    end
  end
end
