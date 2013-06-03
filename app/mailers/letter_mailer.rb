# encoding: UTF-8

class LetterMailer < CommonMailer

  def letter(letter, user)
    @letter = letter
    @user = user
    mail to: user.email, subject: @letter.subject
  end


  class Preview < MailView

    def letter
      letter = Letter.last
      user = letter.testuser || User.first
      mail = LetterMailer.letter(letter, user)
      mail
    end
  end
end
