# encoding: UTF-8

class MinionJob < ActiveRecord::Base
  key :action
  timestamps

  belongs_to :user
end

MinionJob.auto_upgrade!
