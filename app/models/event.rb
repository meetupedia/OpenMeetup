# -*- encoding : utf-8 -*-

class Event < ActiveRecord::Base
  key :title
  key :permalink, :index => true
  key :description, :as => :text
  key :latitude, :as => :float
  key :longitude, :as => :float
  key :gmaps, :as => :boolean
  key :place
  key :country, :as => :string
  key :city, :index => true
  key :street
  key :start_time, :as => :datetime
  key :end_time, :as => :datetime
  timestamps

  belongs_to :user
  belongs_to :group
  has_many :absences, :dependent => :destroy
  has_many :absents, :through => :absences, :source => :user
  has_many :activities, :as => :activable, :dependent => :destroy
  has_many :event_invitations, :dependent => :nullify
  has_many :event_invitation_targets, :dependent => :nullify
  has_many :images, :as => :imageable
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations, :source => :user
  has_many :waves, :dependent => :nullify

  acts_as_gmappable :validation => false
  auto_permalink :title

  after_create :create_admin_participation

  def absence_for(user)
    Absence.find_by_event_id_and_user_id(self.id, user.id)
  end

  def address
    gmaps4rails_address
  end

  def create_admin_participation
    Participation.create :event => self
  end

  def geocode?
    city.present? and street.present?
  end

  def gmaps4rails_address
    "#{self.street}, #{self.city}"
  end

  def participation_for(user)
    Participation.find_by_event_id_and_user_id(self.id, user.id)
  end
end

Event.auto_upgrade!
