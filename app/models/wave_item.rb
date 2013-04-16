# encoding: UTF-8

class WaveItem < ActiveRecord::Base
  key :body, :as => :text
  timestamps
  belongs_to :user
  belongs_to :wave

  validates :body, :presence => true

  after_create :update_wave, :create_wave_notes, :send_letters

  def update_wave
    wave.change!
  end

  def create_wave_notes
    (wave.wave_members - [user]).each do |user|
      WaveNote.create :user_id => user.id, :wave_id => wave.id, :created_at => created_at
    end
  end

  def send_letters
    (wave.wave_members - [user]).each do |user|
      begin
        WaveMailer.new_message(self, user).deliver
      rescue
      end
    end
  end

  def self.per_page
    10
  end
end

WaveItem.auto_upgrade!
