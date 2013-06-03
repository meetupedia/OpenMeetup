# encoding: UTF-8

class Vote < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :voteable, polymorphic: true, counter_cache: true
end

Vote.auto_upgrade!
