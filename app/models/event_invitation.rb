# encoding: UTF-8

class EventInvitation < ActiveRecord::Base
  key :message, :as => :text
  key :email
  key :code
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :event
  belongs_to :invited_user, :class_name => 'User'

  attr_accessor :ids

  before_validation :on => :create do |event_invitation|
    event_invitation.code = SecureRandom.hex(16)
    true
  end
end

EventInvitation.auto_upgrade!
