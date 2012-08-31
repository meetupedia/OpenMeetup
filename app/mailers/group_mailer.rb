# encoding: UTF-8

class GroupMailer < CommonMailer

  def invitation(user, group_invitation)
    @user = group_invitation.user
    @group = group_invitation.group
    @message = group_invitation.message
    set_locale @user.locale
    mail :to => group_invitation.email, :subject => "Meghívó: #{@group.name}"
  end

  def join(user, email, group)
    @user = user
    @group = group
    mail :to => email, :subject => "Csatlakozás: #{@group.name}"
  end


  class Preview < MailView

    def invitation
      user = User.first
      group_invitation = GroupInvitation.first
      mail = GroupMailer.invitation(user, group_invitation)
      mail
    end
  end
end
