# encoding: UTF-8

class GroupInvitationMailer < CommonMailer

  def invitation(group_invitation)
    @invited_user = group_invitation.invited_user
    @group = group_invitation.group
    @message = group_invitation.message
    @user = group_invitation.user
    @code = group_invitation.code
    set_locale @user.locale
    mail :to => group_invitation.email, :subject => "Meghívó: #{@group.name}"
  end


  class Preview < MailView

    def invitation
      group_invitation = GroupInvitation.last
      mail = GroupInvitationMailer.invitation(group_invitation)
      mail
    end
  end
end
