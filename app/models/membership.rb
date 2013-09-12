# encoding: UTF-8

class Membership < ActiveRecord::Base
  key :is_admin, as: :boolean
  timestamps

  belongs_to :user, counter_cache: true
  belongs_to :group, counter_cache: true

  has_many :activities, as: :activable, dependent: :destroy

  attr_protected :is_admin

  after_create do |membership|
    Activity.create_from membership, membership.user, membership.group
    run_later do
      membership.group.admins.each do |user|
        GroupMailer.join(membership, user).deliver if user.email
      end
    end
  end
end

Membership.auto_upgrade!
