class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can :create, Event

      can :create, Group
      can :create_event, Group do |group|
        group.admins.include?(current_user) or group.user == current_user
      end

      can [:update, :destroy], User do |user|
        user == current_user
      end
    else
      can :create, User
    end
  end
end
