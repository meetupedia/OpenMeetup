# encoding: UTF-8

class Activity < ActiveRecord::Base
  timestamps

  belongs_to :activable, :polymorphic => true
  belongs_to :event
  belongs_to :group
  belongs_to :user

  def self.create_from(item, current_user, group, event = nil)
    activity = Activity.create :activable_type => item.class.name, :activable_id => item.id, :user => current_user, :group => group, :event => event
    if group
      (group.members + current_user.followers - [current_user]).uniq.each do |user|
        Notification.create :activity => activity, :group => group, :user => user
        user.increment! :notifications_count
      end
    end
    activity
  end

  def self.per_page
    20
  end
end

Activity.auto_upgrade!
