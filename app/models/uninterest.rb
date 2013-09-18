# encoding: UTF-8

class Uninterest < ActiveRecord::Base
  belongs_to :user
  belongs_to :uninterestable, polymorphic: true
  timestamps
end

Uninterest.auto_upgrade!
