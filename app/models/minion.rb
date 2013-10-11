class Minion
  SETTINGS = {
    new_user: {
      subject: 'Welcome to Meetupedia!'
    },
  }

  def self.set(item, *actions)
    @item = item
    actions.each do |action|
      @minion_job = MinionJob.where(item_type: @item.class.name, item_id: @item.id, action: action, is_processed: false, is_unprocessable: false).first_or_initialize
      if @minion_job.new_record?
        @minion_job.run_at = Minion[:run_at] || Time.now
        @minion_job.save
      end
    end
  end

  def self.unset(item, *actions)
    actions.each do |action|
      MinionJob.where(item_type: item.class.name, item_id: item.id, action: action).delete_all
    end
  end

  def self.reset(item, *actions)
    Minion.unset(item, *actions)
    Minion.set(item, *actions)
  end

  def self.clear(item)
    MinionJob.where(item_type: item.class.name, item_id: item.id).delete_all
  end

  def self.run
    MinionJob.where(is_processed: false, is_unprocessable: false).where('run_at < ?', Time.now).find_each do |minion_job|
      @minion_job = minion_job
      if @item = @minion_job.item
        recipients = Minion[:recipients] || [@item]
        recipients = [recipients] unless recipients.is_a?(Array)
        recipients.each do |recipient|
          if recipient.email.present?
            options = {
              subject: "[Meetupedia] #{Minion[:subject] || 'Message to you'}",
              from: Minion[:from] || Settings.default_email,
            }
            options[:reply_to] = Minion[:reply_to] if Minion[:reply_to].present?
            MinionMailer.job(@minion_job.id, recipient.id, options).deliver
          end
        end
        @minion_job.update_attributes is_processed: true
      else
        @minion_job.update_attributes is_unprocessable: true
      end
    end
  end

  def self.[](key)
    value = Minion::SETTINGS[@minion_job.action.to_sym][key.to_sym]
    value = value.try(:call) if value.is_a?(Proc)
    value
  end
end
