class MembershipSweeper < ActionController::Caching::Sweeper
  observe Membership

  def after_create(membership)
    Activity.create_from membership, membership.user, membership.group
    run_later do
      membership.group.admins.each do |user|
        GroupMailer.join(membership, user).deliver if user.email
      end
    end
  end
end
