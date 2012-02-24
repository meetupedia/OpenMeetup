class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can [:create, :update, :destroy], Event do |event|
        event.group.admins.include?(current_user)
      end

      can :create, Group
      can [:update, :destroy], Group do |group|
        group.user == current_user
      end

      can :create, Membership
      can :destroy, Membership do |membership|
        membership.user == current_user
      end

      can :create, Participation
      can :destroy, Participation do |participation|
        participation.user == current_user
      end

      can [:update, :destroy], User do |user|
        user == current_user
      end
    else
      can :create, User
    end
  end
end
