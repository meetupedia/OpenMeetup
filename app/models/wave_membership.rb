# encoding: UTF-8

class WaveMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :wave

  after_destroy :destroy_wave_note

  def destroy_wave_note
    wave.wave_note_for(user).andand.destroy
  end
end

WaveMembership.auto_upgrade!
