# encoding: UTF-8

class AbsencesController < CommonController
  load_resource :event
  load_resource :absence, through: :event, shallow: true
  authorize_resource

  def create
    unless @event.absence_for(current_user)
      @absence.save
      @absence.event.participation_for(current_user).andand.destroy
      run_later do
        @absence.event.group.admins.each do |user|
          begin
            EventMailer.absence(@absence, user).deliver
          rescue
          end
        end
      end
    end
    redirect_to @event
  end

  def destroy
    @absence.destroy
    redirect_to @absence.event
  end

  def set
    @absence = @event.absences.build
    create
  end
end
