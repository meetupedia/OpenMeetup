# encoding: UTF-8

class Participation < ActiveRecord::Base
  key :is_checkined, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :event, counter_cache: true

  has_many :activities, as: :activable, dependent: :destroy
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  after_create do |participation|
    Activity.create_from participation, participation.user, participation.event.group, participation.event
    participation.event.absence_for(participation.user).andand.destroy
    membership = participation.event.group.memberships.create user: participation.user unless participation.event.group.membership_for(participation.user)
    participation.event.group.admins.each do |user|
      EventMailer.participation(participation, user).deliver if user.email
    end
    Minion.set participation, :participation_reminder, :write_a_review
    Minion.unset participation.event, :event_reminder_for_members
    true
  end
end

Participation.auto_upgrade!
