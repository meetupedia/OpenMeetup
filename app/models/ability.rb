class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can :create, Event do |event|
        event.group.admins.include?(current_user)
      end
      can [:update, :destroy], Event do |event|
        event.user == current_user
      end

      can :create, Group
      can [:update, :destroy], Group do |group|
        group.user == current_user
      end

      can [:update, :destroy], User do |user|
        user == current_user
      end
    else
      can :create, User
    end
  end
end
