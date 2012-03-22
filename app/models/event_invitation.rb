# -*- encoding : utf-8 -*-
class EventInvitation < ActiveRecord::Base
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :event
end

EventInvitation.auto_upgrade!
