# encoding: UTF-8

class VoteMailer < CommonMailer

  def new_vote(vote_id)
    if @vote = Vote.find_by_id(vote_id)
      @recipient = @vote.voteable.user
      @email = @recipient.andand.email
      if @email
        mail to: @email, subject: "#{@vote.user.name} likes your content!"
      end
    end
  end

  class Preview < MailView

    def new_vote
      vote = Vote.last
      mail = VoteMailer.new_vote(vote.id)
      mail
    end
  end
end
