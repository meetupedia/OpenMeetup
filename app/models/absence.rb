# encoding: UTF-8

class Absence < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :event
end

Absence.auto_upgrade!
