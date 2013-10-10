# encoding: UTF-8

class MinionMailer < CommonMailer

  def job(minion_job_id)
    if @minion_job = MinionJob.find_by_id(minion_job_id)
      @item = @minion_job.item
      @user = @minion_job.user
      if @item and @user
        mail to: @user.email, subject: Minion::SUBJECTS[@minion_job.action] || 'Message to you'
      end
    end
  end


  class Preview < MailView

    def post
      minion_job = MinionJob.last
      mail = MinionMailer.job(minion_job.id)
      mail
    end
  end
end
