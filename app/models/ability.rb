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

      can [:create, :destroy, :set], Membership

      can [:create, :destroy, :set], Participation

      can [:update, :destroy], User do |user|
        user == current_user
      end
    else
      can :create, User
    end
  end
end
