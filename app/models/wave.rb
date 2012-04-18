# encoding: UTF-8

class Wave < ActiveRecord::Base
  key :subject
  key :last_changed_at, :as => :datetime
  key :open, :as => :boolean, :default => false
  timestamps

  belongs_to :group
  belongs_to :user
  has_many :wave_memberships, :dependent => :destroy
  has_many :users, :through => :wave_memberships
  has_many :wave_items, :dependent => :destroy
  has_many :wave_notes, :dependent => :destroy
  has_many :notes, :as => :notable, :dependent => :delete_all

  validates :subject, :presence => true

  after_create :change!, :create_initial_membership

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
end

Wave.auto_upgrade!
