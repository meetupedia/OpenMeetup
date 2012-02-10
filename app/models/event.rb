class Event < ActiveRecord::Base
  key :title
  key :description, :as => :text
  key :location
  key :start_time, :as => :datetime
  key :end_time, :as => :datetime
  timestamps

  belongs_to :user
  belongs_to :group
  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :event_invitations, :dependent => :nullify
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations, :class_name => 'User'
  has_many :reviews, :dependent => :destroy

  validates :title, :presence => true
end

Event.auto_upgrade!
