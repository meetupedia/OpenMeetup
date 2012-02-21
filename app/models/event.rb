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
  has_many :participants, :through => :participations, :source => :user
  has_many :reviews, :dependent => :destroy

  validates :title, :presence => true

  after_create :create_admin_participation

  def create_admin_participation
    particiation = Participation.create :event => self
    Activity.create :activable => particiation
  end

  def participation_for(user)
    Participation.find_by_event_id_and_user_id(self.id, user.id)
  end
end

Event.auto_upgrade!
