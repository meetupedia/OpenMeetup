# encoding: UTF-8

class EventInvitation < ActiveRecord::Base
  key :message, :as => :text
  key :email
  key :is_accepted, :as => :boolean
  timestamps

  belongs_to :user
  belongs_to :event
  belongs_to :invited_user, :class_name => 'User'

  attr_accessor :ids
end

EventInvitation.auto_upgrade!
