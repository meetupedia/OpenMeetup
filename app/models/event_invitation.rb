# -*- encoding : utf-8 -*-

class EventInvitation < ActiveRecord::Base
  key :message, :as => :text
  timestamps

  belongs_to :user
  belongs_to :event

  attr_accessor :emails
end

EventInvitation.auto_upgrade!
