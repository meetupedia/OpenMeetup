# encoding: UTF-8

class Participation < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :event

  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers
end

Participation.auto_upgrade!
