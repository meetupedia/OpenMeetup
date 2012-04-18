# encoding: UTF-8

class WaveItem < ActiveRecord::Base
  key :body, :as => :text
  timestamps

  belongs_to :user
  belongs_to :wave, :counter_cache => true
  belongs_to :reply_to, :class_name => 'WaveItem'

  validates :body, :presence => true

  after_create :create_wave_notes

  def create_wave_notes
    wave.change!
    wave.wave_memberships.where(:is_archived => true).each { |membership| membership.update_attributes :is_archived => false, :is_deleted => false }
    wave.wave_memberships.includes(:user).each do |wave_membership|
      unless wave.wave_note_for(wave_membership.user)
        WaveNote.create :user_id => wave_membership.user_id, :wave_id => self.wave_id, :created_at => self.created_at, :is_mailed => wave_membership.disable_notification
      end
    end
  end
end

WaveItem.auto_upgrade!
