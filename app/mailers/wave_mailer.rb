# encoding: UTF-8

class WaveMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host

  def warning(wave_note)
    from Settings.email.noreply
    recipients wave_note.user.email
    subject '[Moly] Új üzenetet kaptál!'
    body :wave_note => wave_note
  end
end
