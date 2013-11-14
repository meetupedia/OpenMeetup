# encoding: UTF-8

class Membership < ActiveRecord::Base
  key :is_admin, as: :boolean
  timestamps

  belongs_to :user, counter_cache: true
  belongs_to :group, counter_cache: true

  has_many :activities, as: :activable, dependent: :destroy

  attr_protected :is_admin

  after_create do
    group.admins.each do |user|
      GroupMailer.join(self, user).deliver if user.email
    end
    Activity.create_from self, user, group
  end
end

Membership.auto_upgrade!
