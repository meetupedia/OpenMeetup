# -*- encoding : utf-8 -*-

class EventInvitation < ActiveRecord::Base
  key :emails, :as => :text
  key :message, :as => :text
  timestamps

  belongs_to :user
  belongs_to :event
end

EventInvitation.auto_upgrade!
