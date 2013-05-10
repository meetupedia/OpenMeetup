# encoding: UTF-8

class VoteMailer < CommonMailer

  def new_vote(vote_id)
    if @vote = Vote.find_by_id(vote_id)
      @recipient = @vote.user
      @email = @recipient.andand.email
      if @email
        mail :to => @email, :subject => 'New starred item'
      end
    end
  end

  class Preview < MailView

    def new_vote
      vote = Vote.last
      mail = WaveMailer.new_vote(vote.id)
      mail
    end
  end
end
