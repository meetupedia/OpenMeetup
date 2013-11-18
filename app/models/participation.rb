# encoding: UTF-8

class Participation < ActiveRecord::Base
  key :is_checkined, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :event, counter_cache: true

  has_many :activities, as: :activable, dependent: :destroy
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers

  after_create do
    event.absence_for(user).andand.destroy
    event.group.memberships.create user: user unless event.group.membership_for(user)
    event.group.admins.each do |user|
      EventMailer.participation(self, user).deliver if user.email
    end
    Minion.set self, :participation_reminder, :write_a_review
    Minion.unset event, :event_reminder_for_members
    Activity.create_from self, user, event.group, event
  end
end

Participation.auto_upgrade!
