# encoding: UTF-8

class Minion

  TIMES = {
    new_user: -> { @item.created_at + 1.day },
    no_readings: -> { 7.days.from_now }
  }

  SUBJECTS = {
    new_user: 'Így használd a Molyt!',
    no_readings: 'Jelöld olvasottnak a könyveidet!'
  }


  def self.create(action, item, user = nil)
    @item = item
    @user = user || @item.is_a?(User) ? @item : @item.user
    minion_job = MinionJob.where(action: action, item_type: @item.class.name, item_id: @item.id, user_id: @user.id).first_or_initialize
    if minion_job.new_record?
      minion_job.run_at = Minion::TIMES[action].call
      minion_job.save
    end
  end

  def self.destroy(action, item)
    MinionJob.where(action: action, item_type: item.class.name, item_id: item.id).destroy_all
  end

  def self.run
    MinionJob.where(is_mailed: false).where('run_at < ?', Time.now).find_each do |minion_job|
      puts minion_job.id
      minion_job.update_attributes is_mailed: true
      MinionMailer.job(minion_job.id).perform
    end
  end
end
