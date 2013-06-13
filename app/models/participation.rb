# encoding: UTF-8

class Participation < ActiveRecord::Base
  key :is_checkined, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :event, counter_cache: true

  has_many :activities, as: :activable, dependent: :destroy
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers
end

Participation.auto_upgrade!
