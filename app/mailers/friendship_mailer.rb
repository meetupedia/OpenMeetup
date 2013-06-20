# encoding: UTF-8

class FriendshipMailer < CommonMailer

  def new_request(friendship_id)
    if @friendship = Friendship.find_by_id(friendship_id)
      @recipient = @friendship.user
      @email = @recipient.email
      mail to: @email, subject: 'New friendship request'
    end
  end

  def confirmed_request(friendship_id)
    if @friendship = Friendship.find_by_id(friendship_id)
      @recipient = @friendship.user
      @email = @recipient.email
      mail to: @email, subject: 'Friendship request accepted'
    end
  end


  class Preview < MailView

    def new_request
      friendship = Friendship.last
      mail = FriendshipMailer.new_request(friendship.id)
      mail
    end

    def confirmed_request
      friendship = Friendship.last
      mail = FriendshipMailer.confirmed_request(friendship.id)
      mail
    end
  end
end
