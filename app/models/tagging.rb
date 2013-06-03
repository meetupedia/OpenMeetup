# encoding: UTF-8

class Tagging < ActiveRecord::Base
  timestamps

  belongs_to :tag
  belongs_to :user
  has_many :activities, as: :activable, dependent: :destroy
end

Tagging.auto_upgrade!
