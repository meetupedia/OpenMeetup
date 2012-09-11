# encoding: UTF-8

class WaveMailer < CommonMailer

  def new_wave_item(wave_item, user)
    @wave_item = wave_item
    @user = user
    mail :to => user.email, :subject => 'Új üzenetet kaptál!'
  end
end
