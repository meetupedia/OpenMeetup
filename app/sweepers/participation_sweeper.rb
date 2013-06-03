class ParticipationSweeper < ActionController::Caching::Sweeper
  observe Participation

  def after_create(participation)
    Activity.create_from participation, participation.user, participation.event.group, participation.event
    participation.event.absence_for(participation.user).andand.destroy
    membership = participation.event.group.memberships.create user: participation.user unless participation.event.group.membership_for(participation.user)
    run_later do
      participation.event.group.admins.each do |user|
        EventMailer.participation(particiation, user).deliver if user.email
      end
    end
  end
end
