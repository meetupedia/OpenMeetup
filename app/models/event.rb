# encoding: UTF-8

class Event < ActiveRecord::Base
  include CommonCommentable
  key :title
  key :permaname, :index => true
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

  belongs_to :city
  belongs_to :group, :touch => true
  belongs_to :user
  has_many :absences, :dependent => :destroy
  has_many :absents, :through => :absences, :source => :user
  has_many :activities, :dependent => :destroy
  has_many :event_invitations, :dependent => :nullify
  has_many :images, :as => :imageable
  has_many :participations, :dependent => :destroy
  has_many :participants, :through => :participations, :source => :user
  has_many :posts, :dependent => :nullify
  has_many :questions, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :waves, :dependent => :nullify

#  unless Settings.disable_gmaps
#    acts_as_gmappable :validation => false
#  end
  auto_permalink :title

  attr_accessor :invite_all_group_members

  before_validation do |event|
    event.permaname = event.permaname.parameterize
    true
  end

  validate :check_permaname
  validate :valid_dates

  after_create :create_admin_participation

  def valid_dates
    if start_time >= end_time
      errors.add(:end_time, I18n.t('errors.messages.endtimebeforestarttime'))
    end
  end

  def check_permaname
    if permaname.present? and permaname_changed? and (Group.find_by_permaname(permaname) or Event.find_by_permaname(permaname))
      errors.add(:permaname, I18n.t('errors.messages.taken'))
    end
  end

  def absence_for(user)
    Absence.find_by_event_id_and_user_id(self.id, user.id)
  end

  def name
    title
  end

#  def address
#    gmaps4rails_address
#  end

  def create_admin_participation
    Participation.create :event => self
  end

#  def geocode?
#    city.present? and street.present?
#  end

#  def gmaps4rails_address
#    @gmaps4rails_address ||= [self.street, self.city.andand.name].select(&:present?).join(', ')
#  end

  def participation_for(user)
    Participation.find_by_event_id_and_user_id(self.id, user.id)
  end
end

Event.auto_upgrade!
