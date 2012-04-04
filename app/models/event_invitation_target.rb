# -*- encoding : utf-8 -*-

class EventInvitationTarget < ActiveRecord::Base
  key :email
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :event
  belongs_to :event_invitation
  belongs_to :invited_user, :class_name => 'User'
end

EventInvitationTarget.auto_upgrade!
