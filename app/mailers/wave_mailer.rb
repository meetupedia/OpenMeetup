# encoding: UTF-8

class WaveMailer < ActionMailer::Base
  default_url_options[:host] = 'openmeetup.net'
  default :from => 'noreply@openmeetup.net'

  def new_wave_item(wave_item, user)
    @wave_item = wave_item
    @user = user
    mail :to => user.email, :subject => 'Új üzenetet kaptál!'
  end
end
