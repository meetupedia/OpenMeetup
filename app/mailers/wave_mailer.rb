# encoding: UTF-8

class WaveMailer < CommonMailer

  def new_message(wave_item, recipient)
    @recipient = recipient
    @email = @recipient.email
    @wave_item = wave_item
    mail :to => @email, :subject => 'New message'
  end

  class Preview < MailView

    def new_message
      wave_item = WaveItem.last
      mail = WaveMailer.new_message(wave_item, User.first)
      mail
    end
  end
end
