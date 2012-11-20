# encoding: UTF-8

class Review < ActiveRecord::Base
  key :review, :as => :text
  timestamps

  belongs_to :user
  belongs_to :event
  belongs_to :group

  has_many :activities, :as => :activable, :dependent => :destroy

  validates_presence_of :review
end

Review.auto_upgrade!
