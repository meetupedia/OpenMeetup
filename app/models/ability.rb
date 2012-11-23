# encoding: UTF-8

class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user
      can [:create, :set], Absence
      can :destroy, Absence do |absence|
        absence.user_id == current_user.id
      end

      can :create, Comment

      can [:create, :update, :destroy, :participations, :users_and_emails], Event do |event|
        event.group.admins.include?(current_user) or current_user.is_admin?
      end
      can :invited, Event do |event|
        event.participants.include?(current_user)
      end

      can :create, EventInvitation

      can :create, Group
      can [:update, :destroy, :requested_members], Group do |group|
        group.admins.include?(current_user) or current_user.is_admin?
      end
      can [:invited, :waves], Group do |group|
        group.members.include?(current_user)
      end

      can :create, GroupInvitation

      can :create, Image

      can :index, Interest
      can [:create, :update], Interest if current_user.is_admin?

      can :create, InterestTagging
      can :destroy, InterestTagging do |interest_tagging|
        interest_tagging.user_id == current_user.id
      end

      can :create, MembershipRequest
      can [:destroy, :confirm], MembershipRequest do |membership_request|
        membership_request.user_id == current_user.id or membership_request.group.admins.include?(current_user)
      end

      can [:create, :set], Membership
      can :destroy, Membership do |membership|
        membership.user_id == current_user.id or membership.group.admins.include?(current_user)
      end
      can [:set_admin, :unset_admin], Membership do |membership|
        (membership.group.admins.include?(current_user) and membership.group.admins.size > 1) or current_user.is_admin?
      end

      can [:index, :destroy], Notification

      can [:create, :set], Participation
      can [:update, :destroy, :checkin], Participation do |participation|
        participation.user_id == current_user.id or participation.event.group.admins.include?(current_user)
      end

      can :create, Post

      can [:create, :destroy], Question do |question|
        question.event.group.admins.include?(current_user) or current_user.is_admin?
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

      can :edit_city, User
      can [:update, :destroy, :settings, :facebook_groups, :waves], User do |user|
        user == current_user
      end
      can :calendar, User do |user|
        user == current_user or current_user.is_admin?
      end

      can :create, UserFollow
      can :destroy, UserFollow do |user_follow|
        user_follow.user == current_user
      end

      can [:index, :show, :create, :edit, :all, :own, :starred, :with_user], Wave

      can :create, WaveItem

      can :create, WaveMembership
      can [:update, :destroy, :set_archive, :set_delete, :set_star], WaveMembership do |wave_membership|
        wave_membership.user == current_user
      end

      can :index, WaveNote
    else
      can :create, User
    end
  end
end
