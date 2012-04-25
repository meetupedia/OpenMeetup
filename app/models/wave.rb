# encoding: UTF-8

class Wave < ActiveRecord::Base
  key :subject
  key :last_changed_at, :as => :datetime
  timestamps

  belongs_to :group
  belongs_to :event
  belongs_to :user
  has_many :wave_items, :dependent => :destroy
  has_many :wave_memberships, :dependent => :destroy
  has_many :wave_members, :through => :wave_memberships, :source => :user
  has_many :wave_notes, :dependent => :destroy

  attr_accessor :body, :recipient_id
  validates :subject, :body, :presence => true

  after_create :change!, :create_initial_membership, :add_recipients


  def add_recipients
    group.members.each { |user| add_wave_member(user) } if group
    event.participants.each { |user| add_wave_member(user) } if event
  end

  def add_wave_member(user)
    WaveMembership.find_or_create_by_wave_id_and_user_id(self.id, user.id)
  end

  def change!
    update_attribute :last_changed_at, Time.zone.now
  end

  def create_initial_membership
    WaveMembership.create :wave_id => self.id, :user_id => self.user.id
  end

  def wave_membership_for(user)
    WaveMembership.find_by_wave_id_and_user_id(self.id, user.id)
  end

  def wave_note_for(user)
    WaveNote.find_by_wave_id_and_user_id(self.id, user.id)
  end

  def self.per_page
    10
  end
end

Wave.auto_upgrade!
