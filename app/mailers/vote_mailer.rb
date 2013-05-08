# encoding: UTF-8

class VoteMailer < CommonMailer

  def new_vote(vote_id)
    if @vote = Vote.find_by_id(vote_id)
      @recipient = recipient
      @email = @recipient.email
      mail :to => @email, :subject => 'Your '
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
