# encoding: UTF-8

class MembershipRequestMailer < CommonMailer

  def created(membership_request, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = membership_request.user
    @group = membership_request.group
    # set_locale @user.locale
    mail :to => @email, :subject => "Join request: #{@group.name}"
  end

  def confirmed(membership_request)
    @recipient = membership_request.user
    @email = @recipient.email
    @user = membership_request.user
    @group = membership_request.group
    mail :to => @email, :subject => "Join confirmed: #{@group.name}"
  end


  class Preview < MailView

    def created
      membership_request = MembershipRequest.last
      mail = MembershipRequestMailer.created(membership_request, User.first)
      mail
    end

    def confirmed
      membership_request = MembershipRequest.last
      mail = MembershipRequestMailer.confirmed(membership_request)
      mail
    end
  end
end
