class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can [:create, :update, :destroy], Event do |event|
        event.group.admins.include?(current_user)
      end
      can :set_participation, Event

      can :create, Group
      can [:update, :destroy], Group do |group|
        group.user == current_user
      end
      can :set_membership, Group

      can [:update, :destroy], User do |user|
        user == current_user
      end
    else
      can :create, User
    end
  end
end
