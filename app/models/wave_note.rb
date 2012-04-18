# encoding: UTF-8

class WaveNote < ActiveRecord::Base
  key :is_mailed, :default => false
  timestamps

  belongs_to :user
  belongs_to :wave

  def self.send_warnings
    puts 'Üzenetfigyelmeztetések küldése'
    where(:is_mailed_is => false).where('created_at < ?', 1.hour.ago).each do |wave_note|
      begin
        wave_note.update_attribute :is_mailed, true
        if wave_note.user.emailable?
          WaveMailer.warning(wave_note).deliver
          puts '  ' + wave_note.user.login
        end
      rescue
      end
    end
  end
end

WaveNote.auto_upgrade!
