# encoding: UTF-8

class GroupMailer < CommonMailer

  def join(membership, user)
    @recipient = user
    @email = @recipient.email
    @user = membership.user
    @group = membership.group
    mail :to => email, :subject => "New member in #{@group.name}: #{@user.name}"
  end


  class Preview < MailView

    def join
      membership = Membership.last
      mail = GroupMailer.join(membership, membership.group.admins.first.email)
      mail
    end
  end
end
