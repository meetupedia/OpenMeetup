# encoding: UTF-8

class WaveMembership < ActiveRecord::Base
  timestamps

  belongs_to :user
  belongs_to :wave, :counter_cache => true

  after_create :create_wave_note
  after_destroy :destroy_wave_note

  def create_wave_note
    WaveNote.create :user_id => self.user.id, :wave_id => self.wave.id, :created_at => self.wave.created_at if self.wave.wave_items.size > 0
  end

  def destroy_wave_note
    wave.wave_note_for(user).andand.destroy
  end
end

WaveMembership.auto_upgrade!
