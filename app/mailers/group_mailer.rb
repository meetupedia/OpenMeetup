# encoding: UTF-8

class GroupMailer < CommonMailer

  def join(user, email, group)
    @user = user
    @group = group
    mail :to => email, :subject => "New member in #{@group.name}: #{@user.name}"
  end


  class Preview < MailView

    def join
      membership = Membership.last
      mail = GroupMailer.join(membership.user, membership.group.admins.first.email, membership.group)
      mail
    end
  end
end
