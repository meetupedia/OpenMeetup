# encoding: UTF-8

class WaveMailer < ActionMailer::Base

  def warning(wave_note)
    recipients wave_note.user.email
    subject 'Új üzenetet kaptál!'
    body :wave_note => wave_note
  end
end
