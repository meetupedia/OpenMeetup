# encoding: UTF-8

class GroupInvitationMailer < CommonMailer

  def invitation(group_invitation)
    @recipient = group_invitation.invited_user
    @email = group_invitation.email
    @user = group_invitation.user
    @group = group_invitation.group
    @message = group_invitation.message
    @code = group_invitation.code
    set_locale @recipient.andand.locale || @user.locale
    mail :to => @email, :subject => "Invitation: #{@group.name}"
  end


  class Preview < MailView

    def invitation
      group_invitation = GroupInvitation.last
      mail = GroupInvitationMailer.invitation(group_invitation)
      mail
    end
  end
end
