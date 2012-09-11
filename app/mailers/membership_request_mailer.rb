# encoding: UTF-8

class MembershipRequestMailer < CommonMailer

  def created(membership_request)
    @user = membership_request.user
    @group = membership_request.group
    set_locale @user.locale
    mail :to => @group.admins.map(&:email).compact.uniq, :subject => "Csatlakozási kérelem: #{@group.name}"
  end

  def confirmed(membership_request)
    @user = membership_request.user
    @group = membership_request.group
    mail :to => @user.email, :subject => "Csatlakozás elfogadva: #{@group.name}"
  end


  class Preview < MailView

    def created
      membership_request = MembershipRequest.last
      mail = MembershipRequestMailer.created(membership_request)
      mail
    end

    def confirmed
      membership_request = MembershipRequest.last
      mail = MembershipRequestMailer.confirmed(membership_request)
      mail
    end
  end
end
