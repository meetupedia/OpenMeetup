class QuestionsController < CommonController
  load_resource :event
  load_resource :question, :through => :event, :shalloe => true

  def create
    @question.event = @event
    @question.save
    redirect_to edit_event_path(@event)
  end

  def destroy
    @question.destroy
    redirect_to edit_event_path(@event)
  end
end
