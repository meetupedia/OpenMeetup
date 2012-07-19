# encoding: UTF-8

class WaveMailer < ActionMailer::Base
  default_url_options[:host] = Settings.host
  default :from => Settings.default_email

  def new_wave_item(wave_item, user)
    @wave_item = wave_item
    @user = user
    mail :to => user.email, :subject => 'Új üzenetet kaptál!'
  end
end
