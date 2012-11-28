# encoding: UTF-8

class GroupMailer < CommonMailer

  def creation(group, recipient)
    @recipient = recipient
    @email = @recipient.email
    @group = group
    @user = @group.user
    mail :to => @email, :subject => "New group: #{@group.name}"
  end

  def join(membership, recipient)
    @recipient = recipient
    @email = @recipient.email
    @user = membership.user
    @group = membership.group
    mail :to => @email, :subject => "New member in #{@group.name}: #{@user.name}"
  end


  class Preview < MailView

    def creation
      group = Group.last
      mail = GroupMailer.creation(group, User.first)
      mail
    end

    def join
      membership = Membership.last
      mail = GroupMailer.join(membership, User.first)
      mail
    end
  end
end
