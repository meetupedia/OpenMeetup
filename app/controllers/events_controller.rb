class EventsController < InheritedResources::Base
  belongs_to :group, :optional => true
  load_resource
  authorize_resource :except => [:index, :show]

  def create
    create!
    create_activity @event
  end

  def set_participation
    participation = Participation.find_or_initialize_by_event_id_and_user_id(@event.id, current_user.id)
    if participation.new_record?
      participation.save
      create_activity participation
    elsif params[:protection].blank?
      participation.destroy
    end
    redirect_to @event
  end
end
