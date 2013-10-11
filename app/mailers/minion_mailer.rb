class MinionMailer < CommonMailer

  def job(minion_job_id, user_id, options = {})
    if @minion_job = MinionJob.find_by_id(minion_job_id) and @user = User.find_by_id(user_id)
      @item = @minion_job.item
      if @item and @user
        mail options.reverse_merge!(to: @user.email)
      end
    end
  end


  class Preview < MailView

    def job
      minion_job = MinionJob.last
      mail = MinionMailer.job(minion_job.id, 1)
      mail
    end
  end
end
