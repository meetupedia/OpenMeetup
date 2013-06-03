# encoding: UTF-8

class QuestionsController < CommonController
  load_resource :event
  load_resource :question, through: :event, shallow: true
  authorize_resource

  def create
    @question.event = @event
    @question.save
    reload_to edit_event_path(@event)
  end

  def destroy
    @question.destroy
    reload_to edit_event_path(@question.event)
  end
end
