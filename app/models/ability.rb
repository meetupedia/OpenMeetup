class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can [:update, :destroy], User do |user|
        user == current_user
      end
      can :create, Group
    else
      can :create, User
    end
  end
end
