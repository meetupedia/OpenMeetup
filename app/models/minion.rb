class Minion
  SETTINGS = {
    participation_reminder: {
      recipients: -> { @item.user },
      run_at: -> { (@item.event.start_time - 1.day).change(hour: 3) },
      subject: -> { "Event tomorrow: #{@item.event.title}" }
    },

    event_reminder_for_members: {
      recipients: -> { @item.group.members },
      run_at: -> { (@item.start_time - 1.day).change(hour: 3) },
      subject: -> { "Event tomorrow: #{@item.title}" }
    },

    new_group_owner_1: {
      subject: 'Congratulations for your first group'
    },

    write_a_review: {
      recipients: -> { @item.user },
      run_at: -> { @item.event.end_time + 1.hour },
      subject: -> { "Write a review about #{@item.event.title}" }
    },

    abandoned_group_1: {
      recipients: -> { @item.user },
      run_at: -> { 30.days.from_now },
      subject: ''
    }
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
              subject: Minion[:subject] || 'Message to you',
              from: Minion[:from] || Settings.default_email,
            }
            options[:reply_to] = Minion[:reply_to] if Minion[:reply_to].present?
            begin
              MinionMailer.job(@minion_job.id, recipient.id, options).deliver
            rescue
            end
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
