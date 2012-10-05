# encoding: UTF-8

class GroupMailer < CommonMailer

  def join(membership, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = membership.user
    @group = membership.group
    mail :to => @email, :subject => "New member in #{@group.name}: #{@user.name}"
  end


  class Preview < MailView

    def join
      membership = Membership.last
      mail = GroupMailer.join(membership, User.first)
      mail
    end
  end
end
