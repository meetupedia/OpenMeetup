# encoding: UTF-8

class Participation < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :event

  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :answers, :dependent => :destroy
end

Participation.auto_upgrade!
