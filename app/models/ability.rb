# -*- encoding : utf-8 -*-

class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can [:create, :update, :destroy], Event do |event|
        event.group.admins.include?(current_user)
      end
      can :invited, Event do |event|
        event.group.admins.include?(current_user)
      end

      can :create, EventInvitation do |event_invitation|
        event_invitation.event.group.admins.include?(current_user)
      end

      can :create, Group
      can [:update, :destroy], Group do |group|
        group.user == current_user or group.admins.include?(current_user)
      end
      can :invited, Group do |group|
        group.admins.include?(current_user)
      end

      can :create, GroupInvitation do |group_invitation|
        group_invitation.group.admins.include?(current_user)
      end

      can [:create, :set], Membership
      can :destroy, Membership do |membership|
        membership.user_id == current_user.id or membership.group.admins.include?(current_user)
      end

      can [:create, :set], Participation
      can :destroy, Participation do |participation|
        participation.user_id == current_user.id or participation.event.group.admins.include?(current_user)
      end

      can :create, Review
      can [:update, :destroy], Review do |review|
        review.user == current_user
      end

      can :create, Tagging
      can :destroy, Tagging do |tagging|
        tagging.user == current_user
      end

      can :create, Tag

      can [:update, :destroy, :dashboard], User do |user|
        user == current_user
      end

      can :create, UserFollow
      can :destroy, UserFollow do |user_follow|
        user_follow.user == current_user
      end
    else
      can :create, User
    end
  end
end
